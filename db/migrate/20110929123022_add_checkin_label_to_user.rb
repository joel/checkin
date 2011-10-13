class AddCheckinLabelToUser < ActiveRecord::Migration
  def change
    add_column :users, :checkin_label_msg, :string
    add_column :users, :proccess_done, :boolean, :default => false
  end
end
