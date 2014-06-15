class Notification < ActiveRecord::Base
  attr_accessible :event_id, :message, :type_of_event

  has_many :user_notifications
  has_many :users, :through => :user_notifications

  validates_presence_of :event_id
  validates_presence_of :type_of_event
end
