class Reminder < ApplicationRecord
  belongs_to :user
  has_one :state

  enum recurrence: [:Daily, :Weekly, :Monthly, :Yearly]

  validates :time, presence: true
  # 3/ on valide la presente de time.
  validates :date, presence: true, if: -> { time.present? }
  # 4/ si time au dessus n'est pas valide,  on ne peut pas validate date
  # on a appliqué le if -> qui est une methode anonyme sur le time.
  # En gros si time n'est pas present (par exemple si chronic18n renvoit nil)
  # alors pas besoin de validate date.

  # TODO: validate pour empecher un time dans le passe

  before_validation :set_date
  # 1/ Avant tout, on appelle set_date, avant de validate time ou date.

  private

  def set_date
    if time.respond_to?(:to_date)
      # 2/ Si du parsing Chronic18n on ne recoit pas 'nil' alors on
      # applique la methode to_date (methode ruby) sur l'instance de time.
      self.date = time.to_date
    end
  end
end
