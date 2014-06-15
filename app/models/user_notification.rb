class UserNotification < ActiveRecord::Base
  attr_accessible :notification_id, :read, :user_id

  belongs_to :user
  belongs_to :notification

  validates_presence_of :user_id
  validates_presence_of :notification_id

  validates_uniqueness_of :notification_id, :allow_nil => true, :scope => :user_id, :message => "can't have duplicate notifications for a user"
end
