class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :person_id
      t.datetime :sent_at
      t.text :at_who
      t.text :content

      t.timestamps
    end
  end
end
