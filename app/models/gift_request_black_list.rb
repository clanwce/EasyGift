class GiftRequestBlackList < ActiveRecord::Base
  attr_accessible :gift_request_id, :user_id

  belongs_to :gift_request
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :gift_request_id

  ALL_LOGGED_IN_USERS = 0
  FOLLOWERS = -1
  FOLLOWED_USERS = -2

  def self.access_denied?(user_id, gift_request_id)
  	return GiftRequestBlackList.where(user_id: user_id, gift_request_id: gift_request_id).present?
  end
end
