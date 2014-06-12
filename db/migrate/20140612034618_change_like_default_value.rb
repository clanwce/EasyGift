class ChangeLikeDefaultValue < ActiveRecord::Migration
  def up
  	rename_column :gift_requests, :dislike, :dislikes
  	rename_column :comments, :like, :likes
  	rename_column :comments, :dislike, :dislikes  

  	change_column :gift_requests, :likes, :integer, :default => 0
  	change_column :gift_requests, :dislikes, :integer, :default => 0

  	change_column :comments, :likes, :integer, :default => 0
  	change_column :comments, :dislikes, :integer, :default => 0
  end

  def down
  	rename_column :gift_requests, :dislikes, :dislike
  	rename_column :comments, :likes, :like
  	rename_column :comments, :dislikes, :dislike

  	change_column :gift_requests, :likes, :integer, :default => nil
  	change_column :gift_requests, :dislikes, :integer, :default => nil

  	change_column :comments, :likes, :integer, :default => nil
  	change_column :comments, :dislikes, :integer, :default => nil
  end
end
