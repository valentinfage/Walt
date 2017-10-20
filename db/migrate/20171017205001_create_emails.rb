class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :object
      t.string :content
      t.string :receiver
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
