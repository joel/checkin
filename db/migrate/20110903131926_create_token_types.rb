class CreateTokenTypes < ActiveRecord::Migration
  def change
    create_table :token_types do |t|
      t.string :title
      t.timestamps
    end
    add_index :token_types, :title, :unique => true
    ['full day','half day', 'free'].each { |title| TokenType.create(:title=>title) }
  end
end
