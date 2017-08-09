class Order < ApplicationRecord
  belongs_to :firm
  belongs_to :user

  has_many :lines, class_name: 'OrderLine', dependent: :destroy
  has_many :statuses, class_name: 'OrderStatus', dependent: :destroy

  accepts_nested_attributes_for :lines,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes[:product_id].blank? }

  validates :contact_name, presence: :true

  scope :pending, -> { joins(:statuses).where('order_statuses.status = :status_one OR order_statuses.status = :status_two', status_one: 1, status_two: 2) }
  scope :date_asc, -> {order('orders.date ASC')}
  scope :date_desc, -> {order('orders.date DESC')}

  def formatted_date
    date.strftime(I18n.t('date.formats.long')) if date
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
