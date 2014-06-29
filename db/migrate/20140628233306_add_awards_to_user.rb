class AddAwardsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :rank, :string, default: 'Stone'
  end
end