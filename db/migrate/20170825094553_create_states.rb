class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.integer :notification_type
      t.timestamp :send_date

      t.timestamps
    end
  end
end
