class Product < ApplicationRecord
  belongs_to :user

  has_many :recipes
  has_many :trades

  def initial_stock_with_unit
    initial_stock.to_s + unit
  end

  def current_stock_with_unit
    current_stock.to_s + unit
  end

  def type_to_show
    type.present? ? Product.available_types[type.to_sym] : Product.available_types[:defaultType]
  end

  def is_composed
    self.class == ComposedProduct
  end

  def self.available_types
    {
        defaultType: 'Producto general',
        ComposedProduct: 'Producto fabricado',
        MaterialProduct: 'Materia prima'
    }
  end

  def self.types_for_select
    [[available_types[:defaultType], nil], [available_types[:ComposedProduct], 'ComposedProduct'], [available_types[:MaterialProduct], 'MaterialProduct']]
  end
end
