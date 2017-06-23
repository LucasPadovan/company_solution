class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  validates :contact_name, presence: :true
end
