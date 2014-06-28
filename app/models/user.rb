class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :reset_password_token, :points
  # attr_accessible :title, :body

  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :authentications

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :gift_request, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :user_notifications
  has_many :notifications, :through => :user_notifications

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
    Notification.where(actor_id: self.id)
  end

  def feed
    feed = []
    followed_users.each do |followed_user|
      feed += followed_user.activity
    end
    feed = feed.sort_by &:created_at
    message_feed = []
    feed.each do |notification|
      notification_hash = {}
      notification_hash["id"] = notification.id
      notification_hash["message"] = notification.constructActivityMessage(self)
      notification_hash["created_at"] = notification.created_at
      message_feed << notification_hash
    end
    message_feed
  end

  # def points_update(type)
  #   case type
  #   when "like"
  #     update_attributes(points: new_count)

end
