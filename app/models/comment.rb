class Comment < ActiveRecord::Base
  attr_accessible :description, :dislike, :final_answer, :like, :gift_request_id, :user_id, :like_count, :dislike_count

  belongs_to :gift_request
  has_many :likes, :dependent => :destroy
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :description
  validates_presence_of :user
  validates_presence_of :gift_request

  validate :one_final_answer, :if => :final_answer_changed?
  validate :email_business_accounts, :if => :final_answer_changed?

  after_create :create_notification
  before_destroy :destroy_notification

  def create_notification
    Notification.create_notification(self, "comment")
  end

  def destroy_notification
    Notification.destroy_notification(self, "comment")
    Notification.destroy_notification(self, "final_answer_selected")
    Notification.destroy_notification(self, "final_answer_selection")
  end

  def one_final_answer
    if Comment.where(gift_request_id: gift_request.id, final_answer: true).count > 0
      errors[:base ] << "A gift request cannot have more than one final answer"
    else
      newpoints = user.points + 500
      user.update_attributes(points: newpoints)
      create_final_answer_notifications
    end
  end

  def email_business_accounts
    #  tags = gift_request.tags
    #  tags.each do |tag|
    #    users = tag.users
    #    user.each do |user|
    #     BusinessUserMailer.delay.final_answer_notification(user)
    #   end
    # end
    BusinessUserMailer.delay.final_answer_notification(User.find(1))
    BusinessUserMailer.delay.final_answer_notification(User.find(2))
    BusinessUserMailer.delay.final_answer_notification(User.find(3))  
  end

  def username
    user.username
  end

  def gift_request_owner
    gift_request.user
  end

  def gift_request_owner_username
    gift_request_owner.username
  end

  private

  def create_final_answer_notifications
    Notification.create_notification(self, "final_answer_selected")
    Notification.create_notification(self, "final_answer_selection")
  end
end
