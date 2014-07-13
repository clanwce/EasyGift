class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  	def authenticate_user!
  		unless signed_in?
  			redirect_to '/landing'
  		end
  	end
end
