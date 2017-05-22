class Product < ApplicationRecord
  belongs_to :user

  def initial_stock_with_unit
    initial_stock.to_s + unit
  end

  def current_stock_with_unit
    current_stock.to_s + unit
  end
end
