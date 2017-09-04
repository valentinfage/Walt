class AddNotificationToReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :phone_notification, :boolean, :default => true
    add_column :reminders, :web_notification, :boolean, :default => true
  end
end
