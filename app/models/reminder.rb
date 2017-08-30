class Reminder < ApplicationRecord
  belongs_to :user
  has_many :states

  enum recurrence: [:Daily, :Weekly, :Monthly, :Yearly]

  validates :time, presence: true
  validates :date, presence: true, if: -> { time.present? }
  # TODO: validate pour empecher un time dans le passe

  before_validation :set_date

  private

  def set_date
    if time.respond_to?(:to_date)
      self.date = time.to_date
    end
  end
end
