class ChangeNotificationTypeNameAndAttributes < ActiveRecord::Migration[5.0]
  def change
     remove_column :states, :notification_type, :integer
     add_column :states, :status, :boolean, :default => false
  end
end
