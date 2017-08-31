class RemoveNotificationsOnUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :web_notification, :boolean
    remove_column :users, :phone_notification, :boolean
  end
end
