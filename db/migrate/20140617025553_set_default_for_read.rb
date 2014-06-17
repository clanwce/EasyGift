class SetDefaultForRead < ActiveRecord::Migration
  def up
  	change_column :user_notifications, :read, :boolean, :default => false
  end

  def down
  	change_column :user_notifications, :read, :boolean, :default => nil
  end
end
