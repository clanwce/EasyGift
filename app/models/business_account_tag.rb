class BusinessAccountTag < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :tag_id, :user_id

  belongs_to :user
  belongs_to :tag
end
