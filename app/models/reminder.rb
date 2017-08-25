class Reminder < ApplicationRecord
  belongs_to :user
  has_many :states

  enum recurrence: [:Daily, :Weekly, :Monthly, :Yearly]
end
