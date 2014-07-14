class UserNotificationsController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def batch_read
		result = {}
		result["success"] = true
		ids = params[:ids]
		ids.each do |id|
			user_notification = UserNotification.find(id)
			if user_notification
				user_notification.update_attributes(read: true)
				result["success"] = false
			end
		end
		render json: result
	end

	def create
		result = {}
		result["success"] = true
		id = params[:id]
		# ids.each do |id|
		user_notification = UserNotification.find(id)
		if user_notification
			user_notification.update_attributes(read: true)
			result["success"] = false
		end
		# end
		render json: result
	end
end