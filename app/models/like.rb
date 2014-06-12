class Like < ActiveRecord::Base
  attr_accessible :comment_id, :gift_request_id, :status, :user_id

  belongs_to :user
  belongs_to :gift_request
  belongs_to :comment

  validate :like_cannot_belong_to_post_and_comment
  validates_uniqueness_of :comment_id, :allow_nil => true, :scope => :user_id
  validates_uniqueness_of :gift_request_id, :allow_nil => true, :scope => :user_id
  validates_presence_of :user_id

  def like_cannot_belong_to_post_and_comment
  	if gift_request_id && comment_id
  		errors[:base ] << "Like cannot belong to both a gift request post and a comment"
  	end
  end

  def username
    user.username
  end

end
