class GiftRequest < ActiveRecord::Base
  attr_accessible :description, :dislike, :likes, :public, :user_id
  has_many :comments
  belongs_to :user
end
