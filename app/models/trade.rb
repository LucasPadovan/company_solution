class Trade < ApplicationRecord
  # Add uniq index to sold_by+product and sold_to+product
  belongs_to :buyer, class_name: 'Firm', foreign_key: :sold_to, optional: true
  belongs_to :seller, class_name: 'Firm', foreign_key: :sold_by, optional: true
  belongs_to :product

  has_many :prices, dependent: :destroy

  validates_presence_of :product_id

  before_validation :ensure_uniqueness_of_pair

  default_scope { order(created_at: :asc) }
  scope :available_prices, -> { joins(:prices).where('prices.available = ?', true) }
  # Mostly used by Product
  scope :only_buyers,      -> { where.not(sold_to: nil) }
  scope :only_sellers,     -> { where.not(sold_by: nil) }

  def available_price
    prices.availables.last
  end

  def price_valid_from(valid_from)
    prices.where('valid_from <= ?', valid_from).sort_by(&:valid_from).last || available_price
  end

  def available_price_with_currency
    if price = available_price
      "#{price.currency} #{price.price}"
    end
  end

  def price_with_taxes
    if price = available_price
      tax_rate   = price.tax_rate || 0
      unit_price = price.price || 0

      unit_price * (1 + tax_rate / 100)
    end
  end

  def formatted_from
    from.strftime(I18n.t('date.formats.default')) if from
  end

  def formatted_to
    to.strftime(I18n.t('date.formats.default')) if to
  end

  def add_new_price(order_line, currency, class_type, date)
    line_price    = order_line.unit_price
    line_tax_rate = order_line.tax_rate

    price_attrs = {
        price:     line_price,
        tax_rate:  line_tax_rate,
        currency:  currency,
        valid_from: date,
        # Only set up an available price if there was an actual order, if not (is a budget only) the price should not be available yet.
        available: class_type != BudgetOrder
    }

    if persisted?
      trade_price         = available_price.price
      trade_tax_rate      = available_price.tax_rate
      should_create_price = line_price != trade_price || line_tax_rate != trade_tax_rate

      prices.create(price_attrs) if should_create_price
    else
      prices.build(price_attrs)

      save
    end
  end

  private
    def ensure_uniqueness_of_pair
      trades = Trade.where(product_id: self.product_id)
      trader = if sold_by
                 ['trades.sold_by = ?', sold_by]
               elsif sold_to
                 ['trades.sold_to = ?', sold_to]
               end

      errors.add(:base, I18n.t('view.trades.duplicated_trade_error')) if trades.where(trader).any?
    end
end
