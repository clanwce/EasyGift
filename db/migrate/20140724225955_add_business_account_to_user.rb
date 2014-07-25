class AddBusinessAccountToUser < ActiveRecord::Migration
  def change
  	  add_column :users, :business_account, :boolean, default: false
  end
end
