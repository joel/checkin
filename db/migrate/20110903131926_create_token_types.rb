class CreateTokenTypes < ActiveRecord::Migration
  def change
    create_table :token_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
