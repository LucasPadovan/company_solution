class Price < ApplicationRecord
  belongs_to :trade

  scope :available, -> { where('available = ?', true) }
end
