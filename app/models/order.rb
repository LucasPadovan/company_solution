class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :lines, class_name: 'OrderLine', dependent: :destroy

  accepts_nested_attributes_for :lines,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes[:product_id].blank? }

  validates :contact_name, presence: :true

  def formatted_date
    date.strftime(I18n.t('time.formats.long')) if date
  end

  def formatted_deliver_from
    expected_deliver_from.strftime(I18n.t('date.formats.long')) if expected_deliver_from
  end

  def formatted_deliver_to
    expected_deliver_to.strftime(I18n.t('date.formats.long')) if expected_deliver_to
  end

  def self.currencies_for_select
    ['$ARS', 'U$D', '$CLP']
  end
end
