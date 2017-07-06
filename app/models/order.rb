class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :order_lines

  accepts_nested_attributes_for :order_lines, allow_destroy: true

  attr_accessor :order_lines_attributes

  validates :contact_name, presence: :true

  def self.currencies_for_select
    ['$ARS', 'U$D', '$CLP']
  end
end
