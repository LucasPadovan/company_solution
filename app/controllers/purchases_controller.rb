class PurchasesController < OrdersController
  @@notices = {
      correctly_created: 'view.orders.correctly_created',
      correctly_updated: 'view.orders.correctly_updated',
      correctly_destroyed: 'view.orders.correctly_destroyed'
  }

  private
  def set_order_type
    @order_type = PurchaseOrder
  end

  def redirect_path(order)
    purchase_path(order)
  end

  def filtered_orders
    apply_filters(PurchaseOrder)
  end

  def set_information
    @information = { title: t('view.orders.types.purchases') }
  end

  # Information for index method
  def set_index_information
    @information[:new_title] = t('view.orders.types.new_purchase')
    @information[:show_path] = purchases_path
    @information[:new_path] = new_purchase_path
  end

  # Information for show method
  def set_show_information
    @information[:subtitle] = t('view.orders.show_title', order_number: @order.number)
    @information[:edit_path] = edit_purchase_path(@order)
    @information[:back_path] = back_path
  end

  # Information for new/create methods.
  def set_new_form_information
    @information[:form_url] = orders_path(@order, order_type: params[:order_type])
    @information[:subtitle] = t('view.orders.types.new_purchase')
    @information[:button_text] = t('view.orders.types.save_purchase')
    @information[:back_path] = back_path
  end

  # Information for edit/update methods.
  def set_edit_form_information
    @information[:form_url] = order_path(@order, order_type: params[:order_type])
    @information[:subtitle] = t('view.orders.types.edit_purchase', order_number: @order.number)
    @information[:button_text] = t('view.orders.types.save_purchase')
    @information[:back_path] = back_path
  end

  def back_path
    purchases_path
  end
end