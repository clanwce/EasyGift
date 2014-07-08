class GiftRequestWhiteList < ActiveRecord::Base
  attr_accessible :gift_request_id, :user_id

  belongs_to :gift_request
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :gift_request_id

  ALL_LOGGED_IN_USERS = 0
  FOLLOWERS = -1
  FOLLOWED_USERS = -2

  def self.has_access?(user_id, gift_request_id)
  	# return false if the user doesnt exist
  	if !User.exists?(user_id)
  		return false
  	end
  	user_wanting_access = User.find(user_id)
  	gift_request_owner = GiftRequest.find(gift_request_id).user
  	if (user_wanting_access == gift_request_owner)
  		return true
  	end
  	# check if all logged in users is set for this gift request, if it is, then check if the user exists, if so then return true
  	if GiftRequestWhiteList.where(gift_request_id: gift_request_id, user_id: ALL_LOGGED_IN_USERS).present?
  		return true
  	end
  	# check if followers is set for this gift request, if it is then check if the user is a follower, if so then return true
  	if GiftRequestWhiteList.where(gift_request_id: gift_request_id, user_id: FOLLOWERS).present? && user_wanting_access.following?(gift_request_owner)
  		return true
  	end
  	# check if followed_users is set for this gift request, if it is then check if the user is a followed_user if so then return true
  	if GiftRequestWhiteList.where(gift_request_id: gift_request_id, user_id: FOLLOWED_USERS).present? && gift_request_owner.following?(user_wanting_access)
  		return true
  	end
  	# check if the user is individually added to the white list
  	if GiftRequestWhiteList.where(gift_request_id: gift_request_id, user_id: user_id).present?
  		return true
  	end
  	return false
  end

end
