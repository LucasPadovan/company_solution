class Price < ApplicationRecord
  belongs_to :trade

  validates :price, presence: true

  default_scope { order(created_at: :desc) }
  scope :availables, -> { where('available = ?', true) }

  before_create :ensure_availability_uniqueness, if: Proc.new { |price| price.available }

  after_initialize :set_defaults
  after_create :update_trade

  def formatted_valid_from
    valid_from.strftime(I18n.t('date.formats.default')) if valid_from
  end

  def formatted_valid_to
    valid_to.strftime(I18n.t('date.formats.default')) if valid_to
  end

  def available_value
    label = available ? 'label.yes' : 'label.no'

    I18n.t(label)
  end

  def set_as_available
    ensure_availability_uniqueness
    update_attribute(:available, true)
  end

  private
    def ensure_availability_uniqueness
      prices = Price.where(trade_id: trade_id)
      prices.update_all(available: false)
    end

    def set_defaults
      self.tax_rate = tax_rate || 21
    end

    def update_trade
      should_update_from = valid_from && (trade.from && trade.from > valid_from) || !trade.from
      should_update_to   = valid_to   && (trade.to && trade.to > valid_to)       || !trade.to

      trade.from = valid_from if should_update_from
      trade.to   = valid_to   if should_update_to

      trade.save
    end
end
