class Budget < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :lines, class_name: 'BudgetLine', dependent: :destroy

  accepts_nested_attributes_for :lines,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes[:product_id].blank? }

  validates :date, presence: :true

  scope :date_asc,  -> { order('budgets.date ASC') }
  scope :date_desc, -> { order('budgets.date DESC') }

  before_commit :update_prices, on: [:create, :update]

  after_initialize :set_defaults

  private
    def update_prices
      trades = Trade.where(sold_to: firm.id)

      lines.each do |order_line|
        product = order_line.product
        trade = trades.where(product_id: product.id).first

        trade ||= Trade.new({
                                sold_to:    firm.id,
                                product_id: product.id
                            })

        trade.add_new_price(order_line, order_line.currency, self.class, date)
      end
    end

    def set_defaults
      contact_name = (firm && firm.contacts.any?) ? firm.contacts.first.try(:name) : ''

      self.number = (Budget.last.try(:number).to_i || 0) + 1 unless number
      self.destinatary = firm.name if firm && !destinatary
      self.contact = I18n.t('view.firms.buys.header_contact', contact: contact_name) unless contact
    end
end
