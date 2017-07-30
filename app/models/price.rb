class Price < ApplicationRecord
  belongs_to :trade

  scope :available, -> { where('available = ?', true) }

  def formatted_valid_from
    valid_from.strftime(I18n.t('date.formats.default')) if valid_from
  end

  def formatted_valid_to
    valid_to.strftime(I18n.t('date.formats.default')) if valid_to
  end
end
