class OrderStatus < ApplicationRecord
  belongs_to :order

  def self.statuses
    %w(pending ongoing shipped completed canceled delayed paid returned)
  end
end
