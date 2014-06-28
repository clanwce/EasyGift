class Notification < ActiveRecord::Base
  attr_accessible :event_id, :type_of_event, :actor_id

  has_many :user_notifications
  has_many :users, :through => :user_notifications

  validates_presence_of :event_id
  validates_presence_of :type_of_event

  validates :type_of_event, inclusion: { in: %w(like comment gift_request final_answer_selected final_answer_selection),#_selection final_answer_selected),
    message: "can only be either like, comment, gift request, final answer selection or final answer selected" }


  def actor
    User.find(actor_id)
  end

  def self.create_notification(event, type)
    notification = Notification.new
    notification.event_id = event.id
    notification.type_of_event = type
    type == "final_answer_selection" ? notification.actor_id = event.gift_request_owner.id : notification.actor_id = event.user.id
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
      end   
    when "comment"
      unless actor == event.gift_request_owner
        UserNotification.create(notification: notification, user: event.gift_request_owner, message: "#{actor.username} has made comments on your post: #{event.gift_request.title}")
      end
      actor_followers.each do |follower|
        unless follower == event.gift_request_owner
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username} has made comments on #{event.gift_request_owner_username}'s post: #{event.gift_request.title}")
        end
      end   
    when "gift_request"
      actor_followers.each do |follower|
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username} has posted a new gift request: #{event.title}")
      end
    when "final_answer_selected"
      UserNotification.create(notification: notification, user: actor, message: "#{event.gift_request_owner_username} has selected your comment on '#{event.gift_request.title}' as the final answer")
      actor_followers.each do |follower|
        unless follower == event.gift_request_owner
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username}'s comment on '#{event.gift_request.title}' was selected as the final answer by #{event.gift_request_owner_username}")
        end     
      end 
    when "final_answer_selection"
      actor_followers = actor.followers
      actee = event.user
      actor_followers.each do |follower|
        unless follower == actee
          UserNotification.create(notification: notification, user: follower, message:  "#{actor.username} has selected #{actee.username}'s comment on '#{event.gift_request.title}' as the final answer")
        end     
      end
    end
  end

    # def self.create_final_answer_notifications(comment)
    #   @notification = Notification.new
    #   @notification.event_id = comment.id
    #   @notification.type_of_event = "final_answer_selection"
    #   @notification.actor_id = comment.gift_request_owner.id

    #   @notification_selected = Notification.new
    #   @notification_selected.event_id = comment.id
    #   @notification_selected.type_of_event = "final_answer_selected"
    #   @notification_selected.actor_id = comment.user.id

    #   if @notification.save && @notification_selected.save
    #     send_final_answer_selection_notifications_to_users(@notification, comment)
    #     send_final_answer_selected_notifications_to_users(@notification_selected, comment)
    #     return true
    #   else
    #     return false 
    #   end
    # end

    # def self.send_final_answer_selection_notifications_to_users(notification, comment)
    #   actor = notification.actor
    #   actors_followers = actor.followers
    #   actee = comment.user
    #   UserNotification.create(notification: notification, user: actee, message: "#{actor.username} selected your comment on '#{comment.gift_request.title}' as the final answer")
    #   actors_followers.each do |follower|
    #     unless follower == actee
    #       UserNotification.create(notification: notification, user: follower, message: "#{actor.username} selected #{actee.username}'s comment on '#{comment.gift_request.title}' as the final answer")
    #     end     
    #   end
    # end

    # def self.send_final_answer_selected_notifications_to_users(notification, comment)
    #   actor = notification.actor
    #   actors_followers = actor.followers
    #   actee = comment.gift_request_owner
    #   actors_followers.each do |follower|
    #     unless follower == actee
    #       UserNotification.create(notification: notification, user: follower, message: "#{actor.username}'s comment on '#{comment.gift_request.title}' was selected as the final answer by #{actee.username}")
    #     end     
    #   end
    # end



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

