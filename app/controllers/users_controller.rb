class UsersController < ApplicationController

	def edit_password
		@user = current_user
	end

  	def update_password
    	@user = current_user
    	# raise params.inspect
    	if @user.update_with_password(params[:user])
      	sign_in(@user, :bypass => true)
      	redirect_to root_path, :notice => "Your Password has been updated!"
    	else
     		render :edit,:locals => { :resource => @user, :resource_name => "user" }
    	end
  	end

end
