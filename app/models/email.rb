class Email < ApplicationRecord
  belongs_to :user
  has_one :stateemail, dependent: :destroy

  validates :receiver, presence: true
  private

end
