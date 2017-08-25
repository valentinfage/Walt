class AddReminderReferencesToStates < ActiveRecord::Migration[5.0]
  def change
    add_reference :states, :reminder, foreign_key: true
  end
end
