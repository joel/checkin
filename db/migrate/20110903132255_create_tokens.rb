class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :token_type_id
      t.integer :person_id
      t.decimal :cost
      t.datetime :start_at
      t.datetime :stop_at
      t.boolean :used
      t.integer :motivation_id
      t.integer :checkin_owner_id
      t.integer :token_owner_id

      t.timestamps
    end
  end
end
