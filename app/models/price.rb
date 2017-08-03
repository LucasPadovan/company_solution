class Price < ApplicationRecord
  belongs_to :trade

  validates :price, presence: true

  scope :availables, -> { where('available = ?', true) }

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
end
