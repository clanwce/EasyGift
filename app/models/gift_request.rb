class GiftRequest < ActiveRecord::Base
  attr_accessible :description, :dislike, :likes, :private_post, :user_id, :like_count, :dislike_count, :title, :views
  has_many :comments, :dependent => :destroy
  belongs_to :user
  has_many :gift_requests_tags
  has_many :tags, :through => :gift_requests_tags
  has_many :likes, :dependent => :destroy
  has_many :user_views, :dependent => :destroy

  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :user
  validates :title, length: { maximum: 100 }

  after_save ThinkingSphinx::RealTime.callback_for(:gift_request)

  MAXIMUM_AMOUNT_OF_TAGS = 5

  after_create :create_notification
  before_destroy :destroy_notification

  has_many :gift_request_black_list
  has_many :gift_request_white_list

  ALL_LOGGED_IN_USERS = 0
  FOLLOWERS = -1
  FOLLOWED_USERS = -2

  validate :private_post_white_list_present

  def private_post_white_list_present
    if private_post
      return gift_request_white_list.present?
    end
  end

  def create_notification
    Notification.create_notification(self, "gift_request")
  end
  def destroy_notification
    Notification.destroy_notification(self, "gift_request")
  end

  def username
  	user.username
  end

  def increment_views
    new_views = views + 1
    self.update_attributes(views: new_views)
  end

  def attach_tags_to_gift_request(tags)
    if tags
      tags.each do |tag|
        tag = Tag.find_by_name(tag)
        if tag
          begin
            self.tags << tag
            tag.increment_gift_request_count
          rescue ActiveRecord::RecordInvalid => e
            errors[:base ] << "You cannot have more than #{MAXIMUM_AMOUNT_OF_TAGS} tags on this gift request." 
            return false
          end
        end
      end
    end
    return true
  end

  def self.top
    GiftRequest.order('like_count DESC')
  end

  def self.popular
    GiftRequest.order('views DESC')
  end

  def user_has_access?(user_id)
    if private_post
      # check if user is in white list & if their not in black list
      if GiftRequestWhiteList.has_access?(user_id, id) && !GiftRequestBlackList.access_denied?(user_id, id)
        return true
      else
        return false
      end
    end
  end

end
