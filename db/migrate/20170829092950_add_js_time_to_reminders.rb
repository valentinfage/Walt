class AddJsTimeToReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :reminders, :jstime, :string
  end
end
