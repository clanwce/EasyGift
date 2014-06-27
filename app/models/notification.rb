class Notification < ActiveRecord::Base
  attr_accessible :event_id, :type_of_event, :actor_id

  has_many :user_notifications
  has_many :users, :through => :user_notifications

  validates_presence_of :event_id
  validates_presence_of :type_of_event

  validates :type_of_event, inclusion: { in: %w(like comment gift_request final_answer),
    message: "can only be either like, comment, gift request, or final answer" }

    def self.create_notification(event, type)
      notification = Notification.new
      notification.event_id = event.id
      notification.type_of_event = type
      notification.actor_id = event.user
      if notification.save
        send_notifications_to_users(notification, event)
        return true
      else
        return false
      end
    end

    def self.send_notifications_to_users(notification, event)
    	actor = notification.actor
    	actor_followers = actor.followers
      case notification.type_of_event
      when "like"
          UserNotification.create(notification: notification, user: event.post_or_comment_owner, message: "#{actor.username} #{event.status}s your #{event.type}")
      actor_followers.each do |follower|
        unless follower == event.post_or_comment_owner
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username} #{event.status}s #{event.post_or_comment_owner.username}'s' #{event.type}")
        end   
      when "comment"
          UserNotification.create(notification: notification, user: event.gift_request_owner, message: "#{actor.username} has made comments on your post: #{event.gift_request.title}")
      actor_followers.each do |follower|
        unless follower == event.gift_request_owner
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username} #has made comments on #{event.gift_request_owner_username}'s post: #{event.gift_request.title}")
        end   
      when "gift_request"
      actor_followers.each do |follower|
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username} has posted a new gift request: #{event.title}")
        end   
      else #final_answer
        
      end

        # UserNotification.create(notification: notification, user: like.user, message: "You #{like.status} #{like_post_or_comment_owner.username}'s #{like.type}")
        # send notification to owner of post or comment liked
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
