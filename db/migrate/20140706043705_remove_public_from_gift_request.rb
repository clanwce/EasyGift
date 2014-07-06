class RemovePublicFromGiftRequest < ActiveRecord::Migration
  def up
  	add_column :gift_requests, :private_post, :boolean, default: false
  	remove_column :gift_requests, :public
  end

  def down
  	add_column :gift_requests, :public, :boolean
  	remove_column :gift_requests, :private_post
  end
end
