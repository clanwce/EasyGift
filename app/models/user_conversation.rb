class UserConversation < ActiveRecord::Base
  attr_accessible :conversation_id, :deleted, :read, :user_id, :last_delete_at
  belongs_to :user
  belongs_to :conversation
  has_many :private_messages, :through => :conversation

  delegate :users, :to => :conversation

  def mark_unread
  	update_attributes(read: false)
  end

  def mark_read
  	update_attributes(read: true)
  end

  def mark_delete
  	update_attributes(deleted: true)
  	set_last_delete_time
  	if conversation.conversation_delete?
  		"Conversation deleted"
  	else
  		if conversation.message_delete?
  			"Message deleted"
  		else
  			"Nothing is deleted"
  		end
  	end
  end

  def set_last_delete_time
  	update_attributes(last_delete_at: updated_at)
  end

end
