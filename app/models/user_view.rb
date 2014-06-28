class UserView < ActiveRecord::Base
  attr_accessible :gift_request_id, :user_id

  validates_presence_of :user_id
  validates_presence_of :gift_request_id
  validates_uniqueness_of :user_id, :allow_nil => true, :scope => :gift_request_id, :message => "can't be 'viewed' more than once"

  after_create :increment_gift_request_views

  belongs_to :user
  belongs_to :gift_request

  validates_presence_of :user
  validates_presence_of :gift_request

  def increment_gift_request_views
  	gift_request.increment_views
  end
end
