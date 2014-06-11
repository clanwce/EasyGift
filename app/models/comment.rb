class Comment < ActiveRecord::Base
  attr_accessible :decription, :dislike, :final_answer, :like, :post_id, :user_id
end
