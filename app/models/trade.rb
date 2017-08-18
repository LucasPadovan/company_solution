class Trade < ApplicationRecord
  # Add uniq index to sold_by+product and sold_to+product
  belongs_to :buyer, class_name: 'Firm', foreign_key: :sold_to, optional: true
  belongs_to :seller, class_name: 'Firm', foreign_key: :sold_by, optional: true
  belongs_to :product

  has_many :prices, dependent: :destroy

  validates_presence_of :product_id

  scope :available_prices, -> { joins(:prices).where('prices.available = ?', true) }

  def available_price
    prices.availables.last
  end

  def available_price_with_currency
    if price = available_price
      "#{price.currency} #{price.price}"
    end
  end

  def price_with_taxes
    if price = available_price
      price.price * (1 + price.tax_rate / 100)
    end
  end

  def formatted_from
    from.strftime(I18n.t('date.formats.default')) if from
  end

  def formatted_to
    to.strftime(I18n.t('date.formats.default')) if to
  end
end
