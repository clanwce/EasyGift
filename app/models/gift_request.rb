class GiftRequest < ActiveRecord::Base
  attr_accessible :description, :dislike, :likes, :public, :user_id
  has_many :comments
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :likes

  validates_presence_of :user_id

  def username
  	user.username
  end
end
