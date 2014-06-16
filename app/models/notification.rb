class Notification < ActiveRecord::Base
  attr_accessible :event_id, :message, :type_of_event

  has_many :user_notifications
  has_many :users, :through => :user_notifications

  validates_presence_of :event_id
  validates_presence_of :type_of_event

  validates :type_of_event, inclusion: { in: %w(like comment gift_request),
    message: "can only be either like, comment, or gift_request" }
end
