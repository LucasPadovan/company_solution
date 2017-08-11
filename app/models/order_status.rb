class OrderStatus < ApplicationRecord
  belongs_to :order

  def status_name
    I18n.t("view.order_statuses.status.#{OrderStatus.statuses.key(status)}")
  end

  def self.statuses
    {
        open: 1,
        ongoing: 2,
        shipped: 3,
        completed: 4,
        canceled: 5,
        delayed: 6,
        paid: 7,
        returned: 8,
    }
  end

  def self.statuses_for_select
    OrderStatus.statuses.map { |key, value| [I18n.t("view.order_statuses.status.#{key}"), value] }
  end
end
