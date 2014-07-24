class Like < ActiveRecord::Base
  attr_accessible :comment_id, :gift_request_id, :status, :user_id

  belongs_to :user
  belongs_to :gift_request
  belongs_to :comment

  validates_presence_of :user
  validates_presence_of :gift_request, :if => lambda{ |object| object.gift_request_id.present? }
  validates_presence_of :comment, :if => lambda{ |object| object.comment_id.present? }
  validate :like_cannot_belong_to_post_and_comment
  validates_uniqueness_of :comment_id, :allow_nil => true, :scope => :user_id, :message => "can't be liked more than once"
  validates_uniqueness_of :gift_request_id, :allow_nil => true, :scope => :user_id, :message => "can't be liked more than once"
  validates_presence_of :user_id
  validates_presence_of :status
  validates :status, inclusion: { in: %w(like dislike),
    message: "can only be either like or dislike" }

  after_create :create_notification
  before_destroy :destroy_notification

  def create_notification
    Notification.create_notification(self, "like")
  end

  def destroy_notification
    Notification.destroy_notification(self, "like")
  end

  def post_or_comment_owner
    if type == "gift request"
      gift_request_user
    else
      comment_user
    end
  end

  def gift_request_object
    if type == "gift request"
      gift_request
    else
      comment.gift_request
    end
  end

  def type
    if gift_request_id
      "gift request"
    else
      "comment"
    end
  end

  def comment_user
    comment.user
  end

  def gift_request_user
    gift_request.user
  end

  def like_cannot_belong_to_post_and_comment
  	if gift_request_id && comment_id
  		errors[:base ] << "Like cannot belong to both a gift request post and a comment"
  	end
  end

  def username
    user.username
  end

  def update_gift_request_or_comment(status, type)
    if type == 'comment'
      if status == 'like'
        new_count = comment_likes + 1
        comment.update_attributes(like_count: new_count)
        newpoints = comment_owner_points + 50
        comment.user.update_attributes(points: newpoints)
      else
        new_count = comment_dislikes + 1
        comment.update_attributes(dislike_count: new_count)
        newpoints = comment_owner_points - 50
        comment.user.update_attributes(points: newpoints)
      end
    else
      if status == 'like'
        new_count = gift_request_likes + 1
        gift_request.update_attributes(like_count: new_count)
        newpoints = gift_request_owner_points + 50
        gift_request.user.update_attributes(points: newpoints)
      else
        new_count = gift_request_dislikes + 1
        gift_request.update_attributes(dislike_count: new_count)
        newpoints = gift_request_owner_points - 50
        gift_request.user.update_attributes(points: newpoints)
      end   
    end
  end

  def update_comment_likes(status)
    if comment
      if status == 'like'
        new_count = comment_likes + 1
        comment.update_attributes(like_count: new_count)
      else
        new_count = comment_dislikes + 1
        comment.update_attributes(dislike_count: new_count)
      end
    end
  end

  def update_gift_request_likes(status)
    if gift_request
      if status == 'like'
        new_count = gift_request_likes + 1
        gift_request.update_attributes(like_count: new_count)
      else
        new_count = gift_request_dislikes + 1
        gift_request.update_attributes(dislike_count: new_count)
      end
    end
  end

  def comment_gift_request
    comment.gift_request
  end

  def comment_likes
    comment.like_count
  end

  def comment_dislikes
    comment.dislike_count
  end

  def gift_request_likes
    gift_request.like_count
  end

  def gift_request_dislikes
    gift_request.dislike_count
  end

  def comment_owner_points
    comment.user.points
  end

  def gift_request_owner_points
    gift_request.user.points
  end

end
