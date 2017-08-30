class ChangeColumnTypeOnReminders < ActiveRecord::Migration[5.0]
  def change
    remove_column :reminders, :time
    add_column :reminders, :time, :datetime
  end
end
