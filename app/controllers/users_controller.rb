class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:generate_new_password_email]

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    # raise params.inspect
    puts "SIDNEYKEY" + params[:user]["reset_password_token"]
    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to '/account_settings', :notice => "Your Password has been updated!"
    else
      redirect_to '/account_settings', :notice => "Your Password was not changed. Try again"
    end
  end

  def reset_password_test
    tokens = User.pluck(:reset_password_token)
    render json: tokens
  end

  	def generate_new_password_email
  		user = User.find_by_email(params[:user_email])
    	if user
    		user.send_reset_password_instructions
    		flash[:notice] = "Reset password instructions have been sent to #{user.email}."
    		redirect_to "/users/sign_in"
    	else
     		flash[:notice] = "#{params[:user_email]} is not registered in the system"
    		redirect_to "/users/sign_in"   		
    	end
  	end

    def show
      @user = User.find(params[:id])
      @activity = @user.activityMessages(current_user)
    end

    def follow
      id = params[:id]
      otherid = params[:otherid]
    thisuser = User.find(id)
    otheruser = User.find(otherid)
    followjson = thisuser.follow!(otheruser)
    flash[:notice] = "Followed successfully."
    render json: followjson
    end

    def unfollow
      id = params[:id]
      otherid = params[:otherid]
    thisuser = User.find(id)
    otheruser = User.find(otherid)
    unfollowjson = thisuser.unfollow!(otheruser)
    flash[:notice] = "Unfollowed successfully."
    render json: unfollowjson
    end

    def upgrade_account
      flag = current_user.upgrade_to_business_account
      if flag
        response={}
        response["flag"]=true
        render json: response
      end
    end

    def downgrade_account
      tags = current_user.subscribed_tags
        if !tags.empty?
          tags.each do |tag|
            current_user.unsubscribe_tags(tag.id)
          end
        end
      flag = current_user.downgrade_to_regular_account
      if flag
        response={}
        response["flag"]=true
        render json: response
      end
    end

    def user_search
      @users = Array.new
      keyword = params[:keyword]
      all_users = User.all

      require 'fuzzystringmatch'
      jarow = FuzzyStringMatch::JaroWinkler.create( :native )
      all_users.each do |user|
          if(jarow.getDistance( user.username.downcase, keyword.downcase ) > 0.8)
            @users << user
          end
      end
      respond_to do |format|
        format.json { 
          render json: @users
        }
      end
    end

    def user_search_ajax
      @users = Array.new
      keyword = params[:keyword]
      all_users = User.all

      require 'fuzzystringmatch'
      jarow = FuzzyStringMatch::JaroWinkler.create( :native )
      all_users.each do |user|
          if(jarow.getDistance( user.username.downcase, keyword.downcase ) > 0.8) && (user.id != current_user.id)
            @users << user
          end
      end
        jsonusers={}
        jsonusers["key"]=params[:key]
        jsonusers["users"]= @users
        render json: jsonusers
    end


end
