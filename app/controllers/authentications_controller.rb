class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json

#   protected

# # This is necessary since Rails 3.0.4
# # See https://github.com/intridea/omniauth/issues/185
# # and http://www.arailsdemo.com/posts/44
#   def handle_unverified_request
#     true
#   end

  def index
    @authentications = Authentication.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # POST /authentications
  # POST /authentications.json
  def create
    debugger
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication #third-party authentication belonging to user is found, so sign them in
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user #third-party authentication is not found and user is logged in, so connect the authentication to their account
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Third-party authentication connected."
      redirect_to '/'
    else #third-party authentication not found and user is not logged in, so create the new user and connect the third-party authentication to their account
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
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
