class AddPointsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :points, :integer, default: 1000
  end
end
