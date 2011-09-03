class CreateMotivations < ActiveRecord::Migration
  def change
    create_table :motivations do |t|
      t.string :title

      t.timestamps
    end
  end
end
