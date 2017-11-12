class Firm < ApplicationRecord
  has_many :budgets
  has_many :contacts
  has_many :orders
  has_many :permissions
  has_many :sells, class_name: 'Trade', foreign_key: :sold_by
  has_many :buys,  class_name: 'Trade', foreign_key: :sold_to

  default_scope { order(name: :asc) }

  def formatted_opens_at
    opens_at.strftime(I18n.t('time.formats.time')) if opens_at
  end

  def formatted_closes_at
    closes_at.strftime(I18n.t('time.formats.time')) if closes_at
  end

  def get_certificates_available
    permissions.only_valids.map { |permission| permission.certificate }.uniq
  end

  # For now first is the best option, ideally should be one permission per
  # certificate valid at the same time.
  def get_valid_permission_for(certificate_id)
    permissions.only_valids.where(certificate_id: certificate_id).first
  end

  def self.firms_for_select
    Firm.all.map{ |firm| [firm.name, firm.id] }
  end
end
