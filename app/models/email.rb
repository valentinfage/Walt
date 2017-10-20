class Email < ApplicationRecord
  belongs_to :user

  validates :receiver, presence: true
  private

end
