class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.timestamps
    end
    add_index :invitations, :follower_id
    add_index :invitations, :followed_id
    add_index :invitations, [:follower_id, :followed_id], :unique => true
  end
end
