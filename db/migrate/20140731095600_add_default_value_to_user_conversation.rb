class AddDefaultValueToUserConversation < ActiveRecord::Migration
  def up
  	change_column :user_conversations, :deleted, :boolean, :default =>false
  	change_column :user_conversations, :read, :boolean, :default =>false
  end
  def down
  	change_column :user_conversations, :deleted, :boolean, :default =>nil
  	change_column :user_conversations, :read, :boolean, :default =>nil
  end	
end
