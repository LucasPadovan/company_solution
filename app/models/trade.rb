class Trade < ApplicationRecord
  belongs_to :buyer, class_name: Firm, foreign_key: :sold_to, optional: true
  belongs_to :seller, class_name: Firm, foreign_key: :sold_by, optional: true
  belongs_to :product

  has_many :prices

  validates_presence_of :product_id

  scope :available_prices, -> { joins(:prices).where('prices.available = ?', true) }

  def available_price
    prices.available.last
  end
end
