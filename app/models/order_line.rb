class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_id, presence: true


  INCREASE_COLORS = {
      first_break: 'green',
      second_break: 'yellow',
      third_break: 'orange',
      fourth_break: 'red'
  }

  def line_total
    subtotal + tax if subtotal && tax
  end

  def calculate_line_increase
    flat_increase = 0
    # Should create a query directly for the order_line joining with the order validating with the firm_id and the order_date
    order_class = order.class

    if order.date && product
      old_order = order_class.where.not('orders.id = :order_id', order_id: order.id).
          where('orders.firm_id = :firm_id', firm_id: order.firm_id).
          where('orders.date < :date', date: order.date).
          joins(:lines).where('order_lines.product_id = :product_id', product_id: product_id).
          order('orders.date DESC').first

      if old_order
        old_order_line = old_order.lines.where(product_id: product_id).first

        if old_order_line
          last_unit_price = old_order_line.unit_price

          increase = unit_price / last_unit_price - 1
          flat_increase = (increase * 100).round(0)
        end
      end
    end

    flat_increase
  end

  def get_increase_color
    increase = calculate_line_increase

    if increase >= 10
      INCREASE_COLORS[:fourth_break]
    elsif increase >= 6
      INCREASE_COLORS[:third_break]
    elsif increase >= 4
      INCREASE_COLORS[:second_break]
    elsif increase >= 2
      INCREASE_COLORS[:first_break]
    end
  end
end
