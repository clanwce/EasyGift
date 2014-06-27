class Comment < ActiveRecord::Base
  attr_accessible :description, :dislike, :final_answer, :like, :gift_request_id, :user_id, :like_count, :dislike_count

  belongs_to :gift_request
  has_many :likes, :dependent => :destroy
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :description

  validate :one_final_answer, :if => :final_answer_changed?

  def one_final_answer
    if Comment.where(gift_request_id: gift_request.id, final_answer: true).count > 0
      errors[:base ] << "A gift request cannot have more than one final answer"
    end
    create_final_answer_notifications
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
    Notification.create_final_answer_notifications(self)
  end
end