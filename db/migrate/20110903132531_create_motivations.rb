class CreateMotivations < ActiveRecord::Migration
  def change
    create_table :motivations do |t|
      t.string :title
      t.timestamps
    end
    add_index :motivations, :title, :unique => true
    ['co-working','meeting', 'guest', 'other'].each do |title|
      Motivation.create(:title=>title)
    end
  end
end
