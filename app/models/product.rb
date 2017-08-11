class Product < ApplicationRecord
  belongs_to :user

  has_many :recipes
  has_many :trades
  has_many :prices, through: :trades

  validates :name, presence: true

  # API helpers
  def unit_price
    price = _best_price

    price.price if price
  end

  def tax_rate
    price = _best_price

    # price.tax_rate if price
    21
  end

  # VIEW helpers
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

  # CLASS methods
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

  def self.products_for_select
    Product.all.map{ |product| [product.name, product.id] }
  end

  # Temporary methods
  # Will be replaced by a better proper price strategy
  def _best_price
    prices.last
  end
end
