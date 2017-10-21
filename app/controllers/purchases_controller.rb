class PurchasesController < OrdersController
  @@notices = {
      correctly_created: 'view.purchases.correctly_created',
      correctly_updated: 'view.purchases.correctly_updated',
      correctly_destroyed: 'view.purchases.correctly_destroyed'
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
    @information = { title: t('view.purchases.title') }
  end

  # Information for index method
  def set_index_information
    @information[:new_title] = t('view.purchases.new_title')
    @information[:show_path] = purchases_path
    @information[:new_path] = new_purchase_path
  end

  # Information for show method
  def set_show_information
    @information[:subtitle] = t('view.orders.show_title', order_number: @order.number)
    @information[:edit_path] = edit_purchase_path(@order)
    @information[:back_path] = back_path
    @information[:status] = @order.get_permissions_status
  end

  # Information for new/create methods.
  def set_new_form_information
    @information[:form_url] = purchases_path(@order)
    @information[:subtitle] = t('view.purchases.new_title')
    @information[:button_text] = t('view.purchases.save')
    @information[:back_path] = back_path
  end

  # Information for edit/update methods.
  def set_edit_form_information
    @information[:form_url] = purchase_path(@order)
    @information[:subtitle] = t('view.purchases.edit_title', order_number: @order.number)
    @information[:button_text] = t('view.purchases.save')
    @information[:back_path] = back_path
  end

  def back_path
    purchases_path
  end

  def update_prices
    order_lines = @order.lines
    trades = Trade.where(sold_by: @order.firm.id)

    order_lines.each do |order_line|
      product       = order_line.product
      line_price    = order_line.unit_price
      line_tax_rate = order_line.tax_rate

      if trade = trades.where(product_id: product.id).first

        trade_price = trade.available_price.price
        trade_tax_rate = trade.available_price.tax_rate

        if line_price != trade_price || line_tax_rate != trade_tax_rate
          trade.prices.create({
            price: line_price,
            available: true,
            tax_rate: line_tax_rate,
            currency: @order.currency
          })
        end
      else
        trade = Trade.new({
          sold_by: @order.firm.id,
          product_id: product.id
        })

        trade.prices.build({
          price: line_price,
          available: true,
          tax_rate: line_tax_rate,
          currency: @order.currency
        })

        trade.save
      end
    end
  end
end