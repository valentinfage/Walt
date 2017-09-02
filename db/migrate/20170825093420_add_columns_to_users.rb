class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :phone_number, :string
    # add_column :users, :phone_notification, :boolean
    # add_column :users, :web_notification, :boolean
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
