class ChangeUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :ambassador, :boolean, :default => false
  end
end
