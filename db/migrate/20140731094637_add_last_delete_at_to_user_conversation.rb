class AddLastDeleteAtToUserConversation < ActiveRecord::Migration
  def change
    add_column :user_conversations, :last_delete_at, :datetime
  end
end
