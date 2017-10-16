class Permission < ApplicationRecord
  belongs_to :certificate
  belongs_to :firm

  default_scope { order(from_date: :desc) }
  scope :only_valids, -> { where('from_date <= :from_date AND to_date > :to_date', from_date: Date.today, to_date: Date.today) }

  STATES = {
      almost_ended: 'almost_ended',
      ended: 'ended',
      not_valid_yet: 'not_valid_yet',
      valid: 'valid'
  }

  def state
    today = Date.today
    wait_time = certificate.wait_time || 2

    if from_date <= today
      if to_date <= today
        STATES[:ended]
      elsif to_date <= today + wait_time.months
        STATES[:almost_ended]
      else
        STATES[:valid]
      end
    else
      STATES[:not_valid_yet]
    end
  end
end
