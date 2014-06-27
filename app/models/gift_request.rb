class GiftRequest < ActiveRecord::Base
  attr_accessible :description, :dislike, :likes, :public, :user_id, :like_count, :dislike_count, :title
  has_many :comments, :dependent => :delete_all
  belongs_to :user
  has_many :gift_requests_tags
  has_many :tags, :through => :gift_requests_tags
  has_many :likes, :dependent => :destroy

  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :description

  # define_index do
  #   indexes :title
  #   indexes description
  # end
#  after_save ThinkingSphinx::RealTime.callback_for(:gift_request)

  MAXIMUM_AMOUNT_OF_TAGS = 5


  def username
  	user.username
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

end
