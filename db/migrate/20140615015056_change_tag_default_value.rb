class ChangeTagDefaultValue < ActiveRecord::Migration
  def up
  	change_column :tags, :gift_request_count, :integer, :default => 0
  end

  def down
  	change_column :tags, :gift_request_count, :integer, :default => nil
  end
end
