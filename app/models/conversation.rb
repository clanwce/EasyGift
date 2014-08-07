class Conversation < ActiveRecord::Base
  attr_accessible :last_message_at
  has_many :private_messages, :dependent => :destroy
  has_many :user_conversations, :dependent => :destroy
  has_many :users, :through => :user_conversations;

  def conversation_delete?
  	if user_conversations.first.deleted && user_conversations.last.deleted
  		self.destroy
  		return true
  	else
  		return false
  	end
  end

  def message_delete?
  	user1_delete_time = user_conversations.first.last_delete_at
	  user2_delete_time = user_conversations.last.last_delete_at
  	if user1_delete_time.nil? || user2_delete_time.nil?
  		return false
  	else
  		if user1_delete_time > user2_delete_time
  			private_messages.where("created_at < '#{user2_delete_time}'").delete_all
  		else
  			private_messages.where("created_at < '#{user1_delete_time}'").delete_all
  		end
      return true
  	end  	
  end

  def show_messages(user_id)
  	time_of_first_message = user_conversations.find_by_user_id(user_id).last_delete_at
  	if time_of_first_message.nil?
  		private_messages.order("created_at DESC")
  	else
  		private_messages.where("created_at > '#{time_of_first_message}'").order("created_at DESC")
  	end
  end

  def mark_as_read(user_id)
	user_conversation = user_conversations.find_by_user_id(user_id)
	if user_conversation.read
		return false
	else
		user_conversation.mark_read
		return true
	end
  end

  def mark_as_unread(user_id)
  	user_conversation = user_conversations.find_by_user_id(user_id)
  	if user_conversation.read
  		user_conversation.mark_unread
		return true
  	else
  		return false
  	end
  end

  def last_message
    private_messages.last
  end

  def all_messages
    private_messages.all
  end
  

  def is_read?(user_id)
    user_conversation = user_conversations.find_by_user_id(user_id)
    if user_conversation.read
      return true
    else
      return false
    end
  end
end
