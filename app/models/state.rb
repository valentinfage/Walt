class State < ApplicationRecord
  belongs_to :reminder, dependent: :destroy
end
