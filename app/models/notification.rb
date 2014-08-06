class Notification < ActiveRecord::Base
  attr_accessible :event_id, :type_of_event, :actor_id

  has_many :user_notifications, :dependent => :destroy
  has_many :users, :through => :user_notifications

  validates_presence_of :event_id
  validates_presence_of :type_of_event
  validates_presence_of :actor_id

  validates :type_of_event, inclusion: { in: %w(like comment gift_request final_answer_selected final_answer_selection),#_selection final_answer_selected),
    message: "can only be either like, comment, gift request, final answer selection or final answer selected" }

  validate :event_exists

  def event_exists
    begin
      event
    rescue ActiveRecord::RecordNotFound => e
      errors[:base ] << e
    end
  end

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

  def self.destroy_notification(event, type)
    unless (notification_to_delete = Notification.where(type_of_event: type, event_id: event.id)).nil?
      notification_to_delete.each do |notification|
        notification.destroy
      end
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
          if event.gift_request_object.user_has_access?(follower.id)
            UserNotification.create(notification: notification, user: follower, message: "#{actor.username} #{event.status}s #{event.post_or_comment_owner.username}'s' #{event.type}")
          end
        end
      end   
    when "comment"
      unless actor == event.gift_request_owner
        UserNotification.create(notification: notification, user: event.gift_request_owner, message: "#{actor.username} has made comments on your post: #{event.gift_request.title}")
      end
      actor_followers.each do |follower|
        unless follower == event.gift_request_owner
          if event.gift_request.user_has_access?(follower.id)
            UserNotification.create(notification: notification, user: follower, message: "#{actor.username} has made comments on #{event.gift_request_owner_username}'s post: #{event.gift_request.title}")
          end
        end
      end   
    when "gift_request"
      actor_followers.each do |follower|
        if event.user_has_access?(follower.id)
          UserNotification.create(notification: notification, user: follower, message: "#{actor.username} has posted a new gift request: #{event.title}")
        end
      end
    when "final_answer_selected"
      UserNotification.create(notification: notification, user: actor, message: "#{event.gift_request_owner_username} has selected your comment on '#{event.gift_request.title}' as the final answer")
      actor_followers.each do |follower|
        unless follower == event.gift_request_owner
          if event.gift_request.user_has_access?(follower.id)
            UserNotification.create(notification: notification, user: follower, message: "#{actor.username}'s comment on '#{event.gift_request.title}' was selected as the final answer by #{event.gift_request_owner_username}")
          end
        end     
      end
    when "final_answer_selection"
      actor_followers = actor.followers
      actee = event.user
      actor_followers.each do |follower|
        unless follower == actee
          if event.gift_request.user_has_access?(follower.id)
            UserNotification.create(notification: notification, user: follower, message:  "#{actor.username} has selected #{actee.username}'s comment on '#{event.gift_request.title}' as the final answer")
          end
        end     
      end
      event.gift_request.subscribed_users.each do |user|
        unless (event.user == user) || (event.gift_request_owner == user)
          UserNotification.create(notification: notification, user: user, message: "New Opportunity! #{actor.username} has selected #{actee.username}'s comment on '#{event.gift_request.title}' as the final answer")
        end
      end
    end
  end

  def formatted_url
    "/gift_requests/" + link_to_url.id.to_s
  end

  def formatted_id
    link_to_url.id.to_s
  end
  
  def gift_request
    GiftRequest.find(formatted_id)
  end

  def link_to_url
    if type_of_event == "like"
      event.gift_request_object
    elsif type_of_event == "comment"
      event.gift_request
    elsif type_of_event == "gift_request"
      event
    elsif type_of_event == "final_answer_selected"
      event.gift_request
    elsif type_of_event == "final_answer_selection"
      event.gift_request
    end
  end

  def event
    if type_of_event == "like"
      Like.find(event_id)
    elsif type_of_event == "comment"
      Comment.find(event_id)
    elsif type_of_event == "gift_request"
      GiftRequest.find(event_id)
    elsif type_of_event == "final_answer_selected"
      Comment.find(event_id)
    elsif type_of_event == "final_answer_selection"
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
    elsif type_of_event == "final_answer_selected"
      constructFinalAnswerSelectedActivity(viewing_user)
    elsif type_of_event == "final_answer_selection"
      constructFinalAnswerSelectionActivity(viewing_user)
    end  
  end

  def constructFinalAnswerSelectedActivity(viewing_user)
    if type_of_event == "final_answer_selected"
      if viewing_user == actor
        actor = "Your"
      else
        actor = self.actor.username + "'s"
      end
      if viewing_user == event.gift_request_owner #gift request owner
        actee = "you"
      else
        actee = event.gift_request_owner.username
      end
      "#{actor} comment on '#{event.gift_request.title}' was selected as the final answer by #{actee}"
    end
  end

  def constructFinalAnswerSelectionActivity(viewing_user)
    if type_of_event == "final_answer_selection"
      if viewing_user == actor
        actor = "You"
      else
        actor = self.actor.username
      end
      if viewing_user == event.user #comment owner
        actee = "your"
      else
        actee = event.user.username + "'s"
      end
      "#{actor} selected #{actee} comment on '#{event.gift_request.title}' as the final answer"
    end
  end

  def constructLikeActivity(viewing_user)
    if type_of_event == "like"
      if viewing_user == actor
        like_actor = "You"
      else
        like_actor = self.actor.username
      end
      if viewing_user == event.post_or_comment_owner
        like_actee = "your"
      else
        like_actee = event.post_or_comment_owner.username + "'s"
      end
      like_actor + " " + event.status + "d " + like_actee + " " + event.type
    end
  end

  def constructCommentActivity(viewing_user)
    if type_of_event == "comment"
      if viewing_user == actor
        actor = "You"
      else
        actor = self.actor.username
      end
      if viewing_user == event.gift_request_owner_username
        actee = "your"
      else
        actee = event.gift_request_owner_username + "'s"
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

