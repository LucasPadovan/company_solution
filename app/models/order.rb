class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :lines, class_name: 'OrderLine', dependent: :destroy

  accepts_nested_attributes_for :lines, allow_destroy: true

  validates :contact_name, presence: :true

  def self.currencies_for_select
    ['$ARS', 'U$D', '$CLP']
  end
end
