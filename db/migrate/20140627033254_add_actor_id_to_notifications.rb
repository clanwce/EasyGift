class AddActorIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :actor_id, :integer
  end
end
