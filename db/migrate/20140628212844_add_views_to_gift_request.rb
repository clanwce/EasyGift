class AddViewsToGiftRequest < ActiveRecord::Migration
  def change
  	add_column :gift_requests, :views, :integer, default: 0
  end
end
