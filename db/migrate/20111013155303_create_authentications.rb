class CreateAuthentications < ActiveRecord::Migration
  
  def self.up
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.timestamps
    end
    change_table(:users) do |t|
      t.remove :rpx_identifier
      t.string :username
    end
    remove_index :users, :rpx_identifier
  end

  def self.down
    change_table(:users) do |t|
      t.remove :username
      t.string :rpx_identifier
    end
    add_index :users, :rpx_identifier, :unique => true
    drop_table :authentications
  end
  
  # def change
  #   create_table :authentications do |t|
  #     t.integer :user_id
  #     t.string :provider
  #     t.string :uid
  #     t.timestamps
  #   end
  # end
  
end
