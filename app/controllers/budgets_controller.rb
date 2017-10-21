class BudgetsController < OrdersController
  @@notices = {
      correctly_created: 'view.budgets.correctly_created',
      correctly_updated: 'view.budgets.correctly_updated',
      correctly_destroyed: 'view.budgets.correctly_destroyed'
  }

  private
  def set_order_type
    @order_type = BudgetOrder
  end

  def redirect_path(order)
    budget_path(order)
  end

  def filtered_orders
    BudgetOrder.date_asc
  end

  def set_information
    @information = { title: t('view.budgets.title') }
  end

  # Information for index method
  def set_index_information
    @information[:new_title] = t('view.budgets.new_title')
    @information[:show_path] = budgets_path
    @information[:new_path] = new_budget_path
  end

  # Information for show method
  def set_show_information
    @information[:subtitle] = t('view.orders.show_title', order_number: @order.number)
    @information[:edit_path] = edit_budget_path(@order)
    @information[:back_path] = back_path
    @information[:status] = @order.get_permissions_status
  end

  # Information for new/create methods.
  def set_new_form_information
    @information[:form_url] = budgets_path(@order)
    @information[:subtitle] = t('view.budgets.new_title')
    @information[:button_text] = t('view.budgets.save')
    @information[:back_path] = back_path
  end

  # Information for edit/update methods.
  def set_edit_form_information
    @information[:form_url] = budget_path(@order)
    @information[:subtitle] = t('view.budgets.edit_title', order_number: @order.number)
    @information[:button_text] = t('view.budgets.save')
    @information[:back_path] = back_path
  end

  def back_path
    budgets_path
  end
end