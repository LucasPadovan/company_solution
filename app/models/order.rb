class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :lines, class_name: 'OrderLine', dependent: :destroy
  has_many :statuses, class_name: 'OrderStatus', dependent: :destroy

  accepts_nested_attributes_for :lines,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes[:product_id].blank? }

  validates :contact_name, presence: :true

  scope :sales, -> { where('orders.type = ?', 'SaleOrder') }
  scope :purchases, -> { where('orders.type = ?', 'PurchaseOrder') }
  scope :budgets, -> { where('orders.type = ?', 'BudgetOrder') }
  scope :pending, -> { joins(:statuses).where('order_statuses.status = :status_one OR order_statuses.status = :status_two', status_one: 1, status_two: 2) }
  scope :date_asc, -> { order('orders.date ASC') }
  scope :date_desc, -> { order('orders.date DESC') }

  before_validation :update_prices, on: [:create, :update]

  def formatted_date
    date.strftime(I18n.t('date.formats.long')) if date
  end

  def formatted_deliver_from
    expected_deliver_from.strftime(I18n.t('date.formats.long')) if expected_deliver_from
  end

  def formatted_deliver_to
    expected_deliver_to.strftime(I18n.t('date.formats.long')) if expected_deliver_to
  end

  def update_prices
    order_lines = lines
    trades = Trade.where(sold_to: firm.id)

    order_lines.each do |order_line|
      product       = order_line.product
      line_price    = order_line.unit_price
      line_tax_rate = order_line.tax_rate

      if trade = trades.where(product_id: product.id).first

        trade_price = trade.available_price.price
        trade_tax_rate = trade.available_price.tax_rate

        if line_price != trade_price || line_tax_rate != trade_tax_rate
          trade.prices.create({
                                  price: line_price,
                                  available: true,
                                  tax_rate: line_tax_rate,
                                  currency: currency
                              })
        end
      else
        trade = Trade.new({
                              sold_to: firm.id,
                              product_id: product.id
                          })

        trade.prices.build({
                               price: line_price,
                               available: true,
                               tax_rate: line_tax_rate,
                               currency: currency
                           })

        trade.save
      end
    end
  end

  def self.currencies_for_select
    ['$ARS', 'U$D', '$CLP']
  end
end
