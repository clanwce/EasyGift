class GiftRequestsTag < ActiveRecord::Base
  attr_accessible :gift_request_id, :tag_id

  belongs_to :gift_request
  belongs_to :tag

  validates_uniqueness_of :gift_request_id, :allow_nil => true, :scope => :tag_id, :message => "can't be associated to a tag more than once"

  validate :max_tags

  MAXIMUM_AMOUNT_OF_TAGS = 5

  def max_tags
    unless gift_request.tags.count < MAXIMUM_AMOUNT_OF_TAGS
       errors[:base ] << "You cannot have more than #{MAXIMUM_AMOUNT_OF_TAGS} tags on this gift request." 
    end
  end
end