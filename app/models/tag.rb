class Tag < ActiveRecord::Base
  attr_accessible :name, :gift_request_count

  has_many :gift_requests_tags
  has_many :gift_requests, :through => :gift_requests_tags
  validates_presence_of :name
  validates_uniqueness_of :name
  validates :name, length: { maximum: 20 }

  has_many :business_account_tags, :dependent => :destroy
  has_many :users, :through => :business_account_tags

  def increment_gift_request_count
  	update_attributes(gift_request_count: gift_request_count+1)
  end

  def decrement_gift_request_count
    update_attributes(gift_request_count: gift_request_count-1)
  end

  def is_subscribed(user_id)
    if users.where(id: user_id).empty?
      return false
    else
      return true
    end
  end

end
