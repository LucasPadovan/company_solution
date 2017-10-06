class Permission < ApplicationRecord
  belongs_to :certificate
  belongs_to :firm
end
