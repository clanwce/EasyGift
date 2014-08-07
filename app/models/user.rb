class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :reset_password_token, :points, :rank, :business_account
  # attr_accessible :title, :body

  validates_presence_of :username
  validates_uniqueness_of :username


  validates :username, length: { maximum: 20 }

  validates :rank, inclusion: { in: %w(Stone Bronze Silver Gold Platnium Diamond Master),
    message: "can only be either Stone Bronze Silver Gold Platnium Diamond Master" }


  before_update :rank_update, if: proc {points_changed?}

  has_many :authentications

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed #people you are following

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower #people following you
  has_many :gift_request, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :user_notifications
  has_many :notifications, :through => :user_notifications
  has_many :user_vews, :dependent => :destroy

  has_many :gift_request_black_list
  has_many :gift_request_white_list

  has_many :business_account_tags, :dependent => :destroy
  has_many :tags, :through => :business_account_tags

  has_many :user_conversations
  has_many :conversations, :through => :user_conversations
  has_many :private_messages, :through => :conversations

  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def followed?(other_user)
    reverse_relationships.find_by_follower_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def activity
    Notification.where(actor_id: self.id).order("created_at DESC")
  end

  def activityMessages(viewing_user)
    message_activity = []
    activity.each do |notification|
      notification_hash = {}
      notification_hash["id"] = notification.id
      notification_hash["type"] = notification.type_of_event
      notification_hash["url"] = notification.formatted_url
      notification_hash["gift_request"] = notification.gift_request
      notification_hash["message"] = notification.constructActivityMessage(viewing_user)
      notification_hash["created_at"] = notification.created_at
      notification_hash["updated_at"] = notification.updated_at
      message_activity << notification_hash
    end
    message_activity
  end

def feed
    feed = []
    followed_users.each do |followed_user|
      feed += followed_user.activity.sort_by(&:created_at)
    end
    feed = feed.sort_by(&:created_at).reverse
    message_feed = []
    feed.each do |notification|
      notification_hash = {}
      notification_hash["id"] = notification.id
      notification_hash["actor_id"] = notification.actor_id
      notification_hash["url"] = notification.formatted_url
      notification_hash["type"] = notification.type_of_event
      notification_hash["gid"] = notification.formatted_id
      notification_hash["gift_request"] = notification.gift_request
      notification_hash["message"] = notification.constructActivityMessage(self)
      notification_hash["created_at"] = notification.created_at
      notification_hash["updated_at"] = notification.updated_at
      message_feed << notification_hash
    end
    message_feed
  end

  def rank_update  
    if points < 1500
      self.rank = "Stone"
    elsif points< 3000
      self.rank = "Bronze"
    elsif points< 5000
      self.rank = "Silver"
    elsif points< 8000
      self.rank = "Gold"
    elsif points< 15000
      self.rank = "Platinum"
    elsif points< 30000
      self.rank = "Diamond"
    else
      self.rank = "Master"
    end  
  end

  def subscribe_tags(tag_id)
    if business_account
      tag = Tag.find(tag_id)
      if ((tag) && (self.tags.where(id:tag_id).empty?)) 
        begin
          self.tags << tag
        end
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def unsubscribe_tags(tag_id)
    if business_account
      tag_to_unsubscribe = business_account_tags.find_by_tag_id(tag_id)
      # tags_to_unsubscribe = BusinessAccountTag.where(tag_id: tag_id, user_id: id)
      #tags_to_unsubscribe.each do |tag|
      tag_to_unsubscribe.destroy
      # end
      return true
    else
      return false
    end
  end

  def upgrade_to_business_account
    update_attributes(business_account: true)
  end

  def downgrade_to_regular_account
    update_attributes(business_account: false)
  end

  def subscribed_tags
    if business_account
      return tags
    else
      return false
    end
  end
# if current_user has past conversation with user, return conversation, else return nil
  def past_user_conversation(user_id)
    past_user_conversation = nil
      conversations.each do |conversation|
        unless conversation.user_conversations.find_by_user_id(user_id).nil?
          past_user_conversation = conversation.user_conversations.find_by_user_id(user_id)
          break
        end
      end
    return past_user_conversation
  end

  def send_private_message(user_id, message)
    if self.id == user_id
      return false
    else
      user_conversation = past_user_conversation(user_id)
      if user_conversation.nil?
        conversation = create_new_conversation(user_id)
      else
        conversation = user_conversation.conversation
        conversation.user_conversations.each do |user_conversation|
          if user_conversation.deleted
            user_conversation.update_attributes(deleted: false)
          end
        end
      end
      new_message = PrivateMessage.new
      new_message.user_id = id
      new_message.conversation_id = conversation.id
      new_message.message = message
      if new_message.save
        conversation.user_conversations.find_by_user_id(user_id).mark_unread
        conversation.user_conversations.find_by_user_id(self.id).mark_read
        conversation.last_message_at = new_message.created_at
        conversation.save
        real_time_message(user_id, new_message,conversation.id)
        return conversation
      else
        return false
      end
    end
  end

  def real_time_message(user_id, new_message,conversation_id)
    to_channel = 'user' + user_id.to_s + '_channel'
    Pusher[to_channel].trigger('new_message', {
      message: new_message.message,
      from: username,
      created_at: new_message.created_at
    })
    from_channel = 'user' + id.to_s + '_channel'
    Pusher[from_channel].trigger('new_message', {
      message: new_message.message,
      from: username,
      created_at: new_message.created_at
    })
    msgchannel = 'user' + user_id.to_s + '_channel'
    Pusher[msgchannel].trigger('new_conv', {
      message: new_message.message,
      from: username,
      conv_id: conversation_id,
      created_at: new_message.created_at
    })
  end

  def create_new_conversation(user_id)
    conversation = Conversation.new
    if conversation.save
      self.conversations << conversation
      User.find(user_id).conversations << conversation
      return conversation
    else
      return false
    end
  end

  def show_all_conversations
    conversations.where("user_conversations.deleted = false").order("last_message_at DESC")
  end

  def delete_conversation(conversation_id)
    user_conversations.find_by_conversation_id(conversation_id).mark_delete
  end



end
