class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :type_of_event
      t.integer :event_id
      t.string :message

      t.timestamps
    end
  end
end
