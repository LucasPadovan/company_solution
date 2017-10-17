class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :lines, class_name: 'OrderLine', dependent: :destroy
  has_many :products, through: :lines
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

  PERMISSIONS_STATUS = {
      proceed: 'proceed',
      warning: 'warning',
      not_proceed: 'not_proceed'
  }

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

  def get_certificates_needed
    products.map{ |product| product.certificates }.flatten.uniq
  end

  # TODO: redo this piece of code.
  def get_permissions_status
    permissions_status = {
        good:    [],
        warning: [],
        missing: [],
        status:  PERMISSIONS_STATUS[:proceed]
    }
    certificates_needed    = get_certificates_needed
    certificates_available = firm.get_certificates_available

    certificates_needed.each do |certificate|
      if certificate.in?(certificates_available)
        valid_permission = firm.get_valid_permission_for(certificate.id)

        if valid_permission.state === 'almost_ended'
          permissions_status[:status] = PERMISSIONS_STATUS[:warning] if permissions_status[:status] != PERMISSIONS_STATUS[:not_proceed]
          permissions_status[:warning].push(certificate.name)
        elsif valid_permission.state === 'valid'
          permissions_status[:status] = PERMISSIONS_STATUS[:proceed] if permissions_status[:status] != PERMISSIONS_STATUS[:not_proceed] || permissions_status[:status] != PERMISSIONS_STATUS[:warning]
          permissions_status[:good].push(certificate.name)
        end

        if expected_deliver_to.present? && valid_permission.to_date > expected_deliver_to
          permissions_status[:status] = PERMISSIONS_STATUS[:not_proceed]
          permissions_status[:missing].push(certificate.name)
        end

      else
        permissions_status[:status] = PERMISSIONS_STATUS[:not_proceed]
        permissions_status[:missing].push(certificate.name)
      end
    end

    permissions_status[:good]    = permissions_status[:good].uniq
    permissions_status[:warning] = permissions_status[:warning].uniq
    permissions_status[:missing] = permissions_status[:missing].uniq

    permissions_status
  end

  def self.currencies_for_select
    ['$ARS', 'U$D', '$CLP']
  end
end
