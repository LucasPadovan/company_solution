class Trade < ApplicationRecord
  belongs_to :buyer, class_name: Firm, foreign_key: :sold_to, optional: true
  belongs_to :seller, class_name: Firm, foreign_key: :sold_by, optional: true

  belongs_to :product

  validates_presence_of :product_id
end
