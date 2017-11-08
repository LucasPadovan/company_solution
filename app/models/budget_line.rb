class BudgetLine < ApplicationRecord
  belongs_to :budget
  belongs_to :product

  INCREASE_COLORS = {
      first_break: 'green',
      second_break: 'yellow',
      third_break: 'orange',
      fourth_break: 'red'
  }

  def calculate_line_increase
    flat_increase = 0

    if budget.date && product
      old_budget = Budget.where.not('budgets.id = :budget_id', budget_id: budget.id).
          where('budgets.firm_id = :firm_id', firm_id: budget.firm_id).
          where('budgets.date < :date', date: budget.date).
          joins(:lines).where('budget_lines.product_id = :product_id', product_id: product_id).
          order('budgets.date DESC').first

      if old_budget
        old_budget_line = old_budget.lines.where(product_id: product_id).first

        if old_budget_line
          last_unit_price = old_budget_line.unit_price

          increase = unit_price / last_unit_price - 1
          flat_increase = (increase * 100).round(0)
        end
      end
    end

    flat_increase
  end

  def get_increase_color
    increase = calculate_line_increase

    if increase >= 10
      INCREASE_COLORS[:fourth_break]
    elsif increase >= 6
      INCREASE_COLORS[:third_break]
    elsif increase >= 4
      INCREASE_COLORS[:second_break]
    elsif increase >= 2
      INCREASE_COLORS[:first_break]
    end
  end
end
