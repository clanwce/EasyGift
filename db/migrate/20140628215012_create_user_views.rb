class CreateUserViews < ActiveRecord::Migration
  def change
    create_table :user_views do |t|
      t.integer :user_id
      t.integer :gift_request_id

      t.timestamps
    end
  end
end
