class AuthenticationsController < ApplicationController


  # POST /authentications
  # POST /authentications.json
  def create
    referrer = request.env["HTTP_REFERER"]
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication && current_user.nil? #third-party authentication belonging to user is found & no user is logged in, so sign them in
      if referrer == ENV['HOMEPAGE_SIGN_IN']
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, authentication.user)
      else
        sign_in authentication.user
        flash[:notice] = "Facebook connected."
        render 'callback', :layout => false
      end
    elsif authentication && current_user == authentication.user
      if referrer == ENV['HOMEPAGE_SIGN_IN'] || referrer == ENV['HOMEPAGE_SIGN_IN2'] || referrer == ENV['HOMEPAGE_SIGN_IN3']
        flash[:notice] = "Already connected"
        redirect_to '/gift_requests'
      else
        render 'callback', :layout => false
      end
    elsif !authentication && current_user #third-party authentication is not found and user is logged in, so create & connect a new authentication to their account
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      if referrer == ENV['HOMEPAGE_SIGN_IN'] || referrer == ENV['HOMEPAGE_SIGN_IN2'] || referrer == ENV['HOMEPAGE_SIGN_IN3']
        flash[:notice] = "Third-party authentication connected."
        redirect_to '/gift_requests'
      else
        flash[:notice] = "Facebook connected."
        render 'callback', :layout => false
      end
    elsif authentication && current_user && authentication.user != current_user #third-party authentication found & user is logged in & user is incorrect user
      if referrer == ENV['HOMEPAGE_SIGN_IN'] || referrer == ENV['HOMEPAGE_SIGN_IN2'] || referrer == ENV['HOMEPAGE_SIGN_IN3']
        flash[:notice] = "Facebook account already connected to another account"
        redirect_to '/gift_requests'
      else
        flash[:notice] = "Facebook connected."
        render 'callback', :layout => false
      end      
    else #third-party authentication not found and user is not logged in, so create the new user and connect the third-party authentication to their account
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        if referrer == ENV['HOMEPAGE_SIGN_IN'] || referrer == ENV['HOMEPAGE_SIGN_IN2'] || referrer == ENV['HOMEPAGE_SIGN_IN3']
          sign_in_and_redirect(:user, user)
        else
          flash[:notice] = "Facebook connected."
          sign_in user
          render 'callback', :layout => false
        end
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def connect_to_account
    if current_user #if user is logged in, create an authentication and connect it to the user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Third-party authentication connected."
      redirect_to '/'
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
