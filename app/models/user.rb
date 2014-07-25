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

  has_many :business_account_tags
  has_many :tags, :through => :business_account_tags

  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
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
      feed += followed_user.activity.sort_by(&:created_at).reverse
    end
    # feed = feed.sort_by &:created_at
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
      if tag
        begin
          self.tags << tag
        end
      end
      return true
    else
      return false
    end
  end

  def unsubscribe_tags(tag_id)
    if business_account
      tags_to_unsubscribe = BusinessAccountTag.where(tag_id: tag_id, user_id: id)
      tags_to_unsubscribe.each do |tag|
        tag.destroy
      end
      return true
    else
      return false
    end
  end

  def upgrade_to_business_account
    update_attributes(business_account: true)
  end

  # def is_business_account
  #   if business_account
  #     return true
  #   else
  #     return false
  #   end
  # end
  def subscribed_tags
    if business_account
      return tags
    else
      return false
    end
  end

end
