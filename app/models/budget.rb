class Budget < ApplicationRecord
  belongs_to :firm

  has_many :lines, class_name: 'BudgetLine', dependent: :destroy

  scope :date_asc,  -> { order('budgets.date ASC') }
  scope :date_desc, -> { order('budgets.date DESC') }

  before_validation :update_prices, on: [:create, :update]

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

        trade.add_new_price(order_line, currency)
      end
    end
end
