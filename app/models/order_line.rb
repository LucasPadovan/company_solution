class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_id, presence: true

  def line_total
    subtotal + tax if subtotal && tax
  end
end
