class Tag < ActiveRecord::Base
  attr_accessible :name, :gift_request_count

  has_many :gift_requests_tags
  has_many :gift_requests, :through => :gift_requests_tags
  validates_presence_of :name
  validates_uniqueness_of :name

  def increment_gift_request_count
  	update_attributes(gift_request_count: gift_request_count+1)
  end

end
