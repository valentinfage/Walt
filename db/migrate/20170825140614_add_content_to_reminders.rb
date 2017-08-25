class AddContentToReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :content, :text
  end
end
