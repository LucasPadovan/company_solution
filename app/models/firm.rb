class Firm < ApplicationRecord
  has_many :contacts
  has_many :orders
  has_many :trades

  def formatted_opens_at
    opens_at.strftime(I18n.t('time.formats.time')) if opens_at
  end

  def formatted_closes_at
    closes_at.strftime(I18n.t('time.formats.time')) if closes_at
  end

  def self.firms_for_select
    Firm.all.map{ |firm| [firm.name, firm.id] }
  end
end
