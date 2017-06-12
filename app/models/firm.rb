class Firm < ApplicationRecord
  has_many :contacts
  has_many :trades
end
