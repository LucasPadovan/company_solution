class Budget < ApplicationRecord
  belongs_to :firm

  has_many :lines, class_name: 'BudgetLine', dependent: :destroy
end
