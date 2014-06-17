class ChangeNotificationMessages < ActiveRecord::Migration
  def up
    add_column :user_notifications, :message, :string
    remove_column :notifications, :message
  end

  def down
    add_column :notifications, :message, :string
    remove_column :user_notifications, :message
  end
end
