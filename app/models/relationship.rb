class Relationship < ActiveRecord::Base
  attr_accessible :followed_id, :follower_id

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validate :users_exists

  def users_exists
  	unless User.exists?(follower_id) && User.exists?(followed_id)
  		errors[:base ] << "Can only follow existing users"
  	end
  end
end
