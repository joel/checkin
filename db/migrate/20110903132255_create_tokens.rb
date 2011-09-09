class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :token_type_id, :user_id, :motivation_id, :checkin_owner_id, :token_owner_id
      t.decimal :cost, :precision => 10, :scale => 2, :default => 0
      t.datetime :start_at, :stop_at
      t.boolean :used, :default => false
      t.timestamps
    end
    [:token_type_id, :user_id, :motivation_id, :checkin_owner_id, :token_owner_id].each do |field|
      add_index :tokens, field, :unique => false
    end
  end
end
