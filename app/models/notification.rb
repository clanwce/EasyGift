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
        UserNotification.create(notification: notification, user: like.user, message: "You #{like.status} #{like_post_or_comment_owner.username}'s #{like.type}")
        # send notification to owner of post or comment liked
        UserNotification.create(notification: notification, user: like_post_or_comment_owner, message: "#{like.user.username} #{like.status}s your #{like.type}")
      likes_owner_followers.each do |follower|
        unless follower == like_post_or_comment_owner
          UserNotification.create(notification: notification, user: follower, message: "#{like.user.username} #{like.status}s #{like_post_or_comment_owner.username}'s' #{like.type}")
        end     
      end
    end

end
