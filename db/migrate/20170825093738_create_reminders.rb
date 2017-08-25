class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.date :date
      t.time :time
      t.integer :recurrence
      t.string :day
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
