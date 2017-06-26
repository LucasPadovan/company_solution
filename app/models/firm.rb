class Firm < ApplicationRecord
  has_many :contacts
  has_many :orders
  has_many :trades

  def self.firms_for_select
    Firm.all.map{ |firm| [firm.name, firm.id] }
  end
end
