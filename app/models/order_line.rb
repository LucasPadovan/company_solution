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
    # get order_date
    # get last_product_price which valid_from < order_date and valid_to > order_date
    # compare product > trade > available_price with last_product_price

    #return one of the INCREASE_COLORS according to the amount of increase between last_product_price and available_price
  end
end
