class AddIndexToUserViews < ActiveRecord::Migration
  def up
  	add_index :user_views, [:user_id, :gift_request_id], unique: true
  end

  def down
  	remove_index :user_views, [:user_id, :gift_request_id]
  end
end
