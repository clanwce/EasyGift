class Like < ActiveRecord::Base
  attr_accessible :comment_id, :gift_request_id, :status, :user_id
end
