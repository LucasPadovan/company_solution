class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :lines, class_name: 'OrderLine', dependent: :destroy
  has_many :statuses, class_name: 'OrderStatus', dependent: :destroy

  accepts_nested_attributes_for :lines,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes[:product_id].blank? }

  validates :contact_name, presence: :true

  scope :sales,     -> { where('orders.type = ?', 'SaleOrder') }
  scope :purchases, -> { where('orders.type = ?', 'PurchaseOrder') }
  scope :budgets,   -> { where('orders.type = ?', 'BudgetOrder') }
  scope :pending,   -> { joins(:statuses).where('order_statuses.status = :status_one OR order_statuses.status = :status_two', status_one: 1, status_two: 2) }
  scope :date_asc,  -> { order('orders.date ASC') }
  scope :date_desc, -> { order('orders.date DESC') }

  before_validation :update_prices, on: [:create, :update]

  def formatted_date
    I18n.l(date, format: I18n.t('date.formats.long')) if date
  end

  def formatted_deliver_from
    I18n.l(expected_deliver_from, format: I18n.t('date.formats.long')) if expected_deliver_from
  end

  def formatted_deliver_to
    I18n.l(expected_deliver_to, format: I18n.t('date.formats.long')) if expected_deliver_to
  end

  def update_prices
    trades = Trade.where(sold_to: firm.id)

    lines.each do |order_line|
      product = order_line.product
      trade = trades.where(product_id: product.id).first

      trade ||= Trade.new({
        sold_to:    firm.id,
        product_id: product.id
      })

      trade.add_new_price(order_line, currency)
    end
  end

  def self.currencies_for_select
    ['$ARS', 'U$D', '$CLP']
  end
end
