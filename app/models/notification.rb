class Notification < ActiveRecord::Base
  attr_accessible :event_id, :type_of_event, :actor_id

  has_many :user_notifications
  has_many :users, :through => :user_notifications

  validates_presence_of :event_id
  validates_presence_of :type_of_event

  validates :type_of_event, inclusion: { in: %w(like comment gift_request final_answer_selection final_answer_selected),
    message: "can only be either like, comment, gift request, final answer selection or final answer selected" }

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

    def self.create_final_answer_notifications(comment)
      @notification = Notification.new
      @notification.event_id = comment.id
      @notification.type_of_event = "final_answer_selection"
      @notification.actor_id = comment.gift_request_owner.id

      @notification_selected = Notification.new
      @notification_selected.event_id = comment.id
      @notification_selected.type_of_event = "final_answer_selected"
      @notification_selected.actor_id = comment.user.id

      if @notification.save && @notification_selected.save
        send_final_answer_selection_notifications_to_users(@notification, comment)
        send_final_answer_selected_notifications_to_users(@notification_selected, comment)
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

    def self.send_final_answer_selection_notifications_to_users(notification, comment)
      actor = notification.actor
      actors_followers = actor.followers
      actee = comment.user
      UserNotification.create(notification: notification, user: actee, message: "#{actor.username} selected your comment on '#{comment.gift_request.title}' as the final answer")
      actors_followers.each do |follower|
        unless follower == actee
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username} selected #{actee.username}'s comment on '#{comment.gift_request.title}' as the final answer")
        end     
      end
    end

    def self.send_final_answer_selected_notifications_to_users(notification, comment)
      actor = notification.actor
      actors_followers = actor.followers
      actee = comment.gift_request_owner
      actors_followers.each do |follower|
        unless follower == actee
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username}'s comment on '#{comment.gift_request.title}' was selected as the final answer by #{actee.username}")
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