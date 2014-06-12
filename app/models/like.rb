class Like < ActiveRecord::Base
  attr_accessible :comment_id, :gift_request_id, :status, :user_id

  belongs_to :user
  belongs_to :gift_request
  belongs_to :comment

  validate :like_cannot_belong_to_post_and_comment
  validates_uniqueness_of :comment_id, :allow_nil => true, :scope => :user_id, :message => "can't be liked more than once"
  validates_uniqueness_of :gift_request_id, :allow_nil => true, :scope => :user_id, :message => "can't be liked more than once"
  validates_presence_of :user_id

  def like_cannot_belong_to_post_and_comment
  	if gift_request_id && comment_id
  		errors[:base ] << "Like cannot belong to both a gift request post and a comment"
  	end
  end

  def username
    user.username
  end

  def update_comment_likes(status)
    if comment
      if status == 'like'
        comment_likes += 1
      else
        update_comment_likes += 1
      end
    end
  end

  def update_gift_request_likes(status)
    debugger
    if gift_request
      if status == 'like'
        gift_request_likes +=1
      else
        gift_request_dislikes +=1
      end
    end
  end

  def comment_likes
    comment.likes
  end

  def comment_dislikes
    comment.dislike
  end

  def gift_request_likes
    gift_request.likes
  end

  def gift_request_dislikes
    gift_request.dislikes
  end

end
