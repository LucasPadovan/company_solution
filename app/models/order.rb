class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  validates :contact_name, presence: :true

  def self.currencies_for_select
    ['$ARS', 'U$D', '$CLP']
  end
end
