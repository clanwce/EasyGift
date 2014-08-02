class AddIndexToBusinessTagAndUserConversation < ActiveRecord::Migration
  def change
  	add_index :business_account_tags, [:user_id, :tag_id], unique: true
  	add_index :user_conversations, [:user_id, :conversation_id], unique: true
  end
end
