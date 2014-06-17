class Notification < ActiveRecord::Base
  attr_accessible :event_id, :message, :type_of_event

  has_many :user_notifications
  has_many :users, :through => :user_notifications

  validates_presence_of :event_id
  validates_presence_of :type_of_event

  validates :type_of_event, inclusion: { in: %w(like comment gift_request final_answer),
    message: "can only be either like, comment, gift request, or final answer" }

    def self.create_like_notification(like)
    	@notification = Notification.new
    	@notification.event_id = like.id
    	@notification.type_of_event = "like"
    	@notification.message = "#{like.user.username} liked #{like.post_or_comment_owner.username}'s #{like.type}"
    	if @notification.save
    		send_like_notifications_to_users(@notification, like)
    		return true
    	else
    		return false
    	end
    end

    # private

    def self.send_like_notifications_to_users(notification, like)
    	like_post_or_comment_owner = like.post_or_comment_owner
    	likes_owner_followers = like.user.followers
    	unless likes_owner_followers.include?(like_post_or_comment_owner)
    		notification.users << like_post_or_comment_owner
    	end
    	notification.users << likes_owner_followers
    end

end
