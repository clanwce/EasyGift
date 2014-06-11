class Comment < ActiveRecord::Base
  attr_accessible :description, :dislike, :final_answer, :like, :gift_request_id, :user_id

  belongs_to :gift_request
  has_many :likes
  belongs_to :user

  def username
  	user.username
  end
end
