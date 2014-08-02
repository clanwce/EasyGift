class PrivateMessage < ActiveRecord::Base
  attr_accessible :conversation_id, :message, :user_id
  belongs_to :user
  belongs_to :conversation
  
end
