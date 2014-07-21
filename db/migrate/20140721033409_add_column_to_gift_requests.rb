class AddColumnToGiftRequests < ActiveRecord::Migration
  def change
    add_column :gift_requests, :facebook_id, :integer
  end
end
