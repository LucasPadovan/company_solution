class Recipe < ApplicationRecord
  belongs_to :product

  validates_presence_of :name, :product_id
end
