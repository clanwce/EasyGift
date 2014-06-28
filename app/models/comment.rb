class Comment < ActiveRecord::Base
  attr_accessible :description, :dislike, :final_answer, :like, :gift_request_id, :user_id, :like_count, :dislike_count

  belongs_to :gift_request
  has_many :likes, :dependent => :destroy
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :description

  validate :one_final_answer, :if => :final_answer_changed?

  after_create :create_notification

  def create_notification
    Notification.create_notification(self, "comment")
  end

  def one_final_answer
    if Comment.where(gift_request_id: gift_request.id, final_answer: true).count > 0
      errors[:base ] << "A gift request cannot have more than one final answer"
    else
      create_final_answer_notifications
    end
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
