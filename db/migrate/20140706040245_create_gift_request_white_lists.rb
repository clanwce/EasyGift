class CreateGiftRequestWhiteLists < ActiveRecord::Migration
  def change
    create_table :gift_request_white_lists do |t|
      t.integer :gift_request_id
      t.integer :user_id
      t.timestamps
    end
  end
end
