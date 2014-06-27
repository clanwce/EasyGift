class Notification < ActiveRecord::Base
  attr_accessible :event_id, :type_of_event, :actor_id

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
      @notification.actor_id = like.user.id
    	if @notification.save
    		send_like_notifications_to_users(@notification, like)
    		return true
    	else
    		return false
    	end
    end

    def self.send_like_notifications_to_users(notification, like)
    	like_post_or_comment_owner = like.post_or_comment_owner
    	likes_owner_followers = like.user.followers
        # UserNotification.create(notification: notification, user: like.user, message: "You #{like.status} #{like_post_or_comment_owner.username}'s #{like.type}")
        # send notification to owner of post or comment liked
        UserNotification.create(notification: notification, user: like_post_or_comment_owner, message: "#{like.user.username} #{like.status}s your #{like.type}")
      likes_owner_followers.each do |follower|
        unless follower == like_post_or_comment_owner
          UserNotification.create(notification: notification, user: follower, message: "#{like.user.username} #{like.status}s #{like_post_or_comment_owner.username}'s' #{like.type}")
        end     
      end
    end

    def actor
      User.find(actor_id)
    end

    def event
      if type_of_event == "like"
        Like.find(event_id)
      elsif type_of_event == "comment"
        Comment.find(event_id)
      elsif type_of_event == "gift_request"
        GiftRequest.find(event_id)
      elsif type_of_event == "final_answer"
        # WE NEED TO THINK ABOUT THIS
        Comment.find(event_id)
      end
    end

    def constructActivityMessage(viewing_user)
      if type_of_event == "like"
        constructLikeActivity(viewing_user)
      elsif type_of_event == "comment"
        constructCommentActivity(viewing_user)
      elsif type_of_event == "gift_request"
        constructGiftRequestActivity(viewing_user)
      end     
    end

    def constructLikeActivity(viewing_user)
      if type_of_event == "like"
        if viewing_user == actor
          like_actor = "You"
        else
          like_actor = actor.username
        end
        if viewing_user == event.post_or_comment_owner
          like_actee = "your"
        else
          like_actee = event.post_or_comment_owner.username + "'s"
        end
        like_actor + " " + event.status + "s " + like_actee + " " + event.type
      end
    end

    def constructCommentActivity(viewing_user)
      if type_of_event == "comment"
        if viewing_user == actor
          actor = "You"
        else
          actor = actor.username
        end
        if viewing_user == event.post_or_comment_owner
          actee = "your"
        else
          actee = event.post_or_comment_owner.username + "'s"
        end
        actor + " commented on " + actee + " gift request"
      end
    end

    def constructGiftRequestActivity(viewing_user)
      if type_of_event == "gift_request"
        if viewing_user == actor
          "You created a gift request post called " + event.title
        else
          actor.username + " created a gift request post called " + event.title
        end       
      end
    end
end
