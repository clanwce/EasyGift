class Like < ActiveRecord::Base
  attr_accessible :comment_id, :gift_request_id, :status, :user_id

  belongs_to :user
  belongs_to :gift_request
  belongs_to :comment
end
