class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.integer :user_id
      t.integer :conversation_id
      t.text :message

      t.timestamps
    end
  end
end
