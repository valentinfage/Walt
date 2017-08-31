class RemoveNotificationsOnUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :reminders, :web_notification, :boolean
    remove_column :reminders, :phone_notification, :boolean
  end
end
