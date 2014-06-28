class GiftRequest < ActiveRecord::Base
  attr_accessible :description, :dislike, :likes, :public, :user_id, :like_count, :dislike_count, :title, :views
  has_many :comments, :dependent => :delete_all
  belongs_to :user
  has_many :gift_requests_tags
  has_many :tags, :through => :gift_requests_tags
  has_many :likes, :dependent => :destroy
  has_many :user_views, :dependent => :destroy

  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :description

  after_save ThinkingSphinx::RealTime.callback_for(:gift_request)

  MAXIMUM_AMOUNT_OF_TAGS = 5

  after_create :create_notification

  def create_notification
    Notification.create_notification(self, "gift_request")
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

end
