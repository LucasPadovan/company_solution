class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_order_type, only: [:new, :create]
  before_action :set_information

  # GET /orders
  def index
    @orders = filtered_orders

    case params[:order_type]
      when 'purchase'
        translation_key = 'view.orders.types.new_purchase'
        show_path = purchases_path
      when 'budget'
        translation_key = 'view.orders.types.new_budget'
        show_path = budgets_path
      else
        translation_key = 'view.orders.types.new_sale'
        show_path = orders_path
    end

    @information[:new_title] = t(translation_key)
    @information[:show_path] = show_path
  end

  # GET /orders/1
  def show
    @information[:subtitle] = t('view.orders.show_title', order_number: @order.number)
    @information[:back_url] = case params[:order_type]
                                when 'purchase'  then purchases_path
                                when 'budget'    then budgets_path
                                else                  orders_path
                              end
  end

  # GET /orders/new
  def new
    @order = @order_type.new

    new_form_information

    @order.number = (@order_type.last.try(:number) || 0) + 1
    @order.date = Date.today
  end

  # GET /orders/1/edit
  def edit
    edit_form_information
  end

  # POST /orders
  def create
    new_form_information
    @order = @order_type.new(order_params)

    @order.date = Date.today
    @order.user = current_user
    @order.statuses.build({
      status: OrderStatus.statuses[:open]
    })

    if @order.save
      flash[:type] = 'success'
      redirect_to redirect_path(@order), notice: t('view.orders.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    edit_form_information

    if @order.update(order_params)
      flash[:type] = 'primary'
      redirect_to redirect_path(@order), notice: t('view.orders.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    flash[:type] = 'error'
    redirect_to back_path(@order), notice: t('view.orders.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_order_type
      @order_type = case params[:order_type]
                      when 'purchase' then PurchaseOrder
                      when 'budget'   then BudgetOrder
                      else                 SaleOrder
                    end
    end

    def redirect_path(order)
      case order
        when PurchaseOrder then purchase_path(order)
        when BudgetOrder   then budget_path(order)
        else                    order_path(order)
      end
    end

    def filtered_orders
      # If this changes, check the routes.rb file.
      case params[:order_type]
        when 'purchase'  then apply_filters(PurchaseOrder)
        when 'budget'    then BudgetOrder.date_asc
        else                  apply_filters(SaleOrder)
      end
    end

    def apply_filters(_orders)
      should_filter_by_status = params[:status_id].present? && params[:status_id] != '0'
      should_get_pending_orders = params[:status_id].blank?
      query = []
      query_params = {}
      orders = _orders

      if params[:firm_id].present?
        query << ['firm_id = :firm_id']
        query_params[:firm_id] = params[:firm_id]
      end

      if params[:date].present?
        query << ['date = :date']
        query_params[:date] = params[:date]
      end

      if should_filter_by_status
        query << ['order_statuses.status = :status_id']
        query_params[:status_id] = params[:status_id]
      end

      if query.length > 0
        query = query.join(' AND ')

        orders = orders.joins(:statuses).where(query, query_params)
      end

      if should_get_pending_orders
        orders = orders.pending
      end

      orders.date_asc
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(
          :id,
          :firm_id,
          :number,
          :date,
          :contact_name,
          :taxes,
          :deliver_fee,
          :packaging_fee,
          :subtotal,
          :total,
          :currency,
          :expected_deliver_from,
          :expected_deliver_to,
          :tracking_code,
          :detail,
          :type,
          :user_id,

          lines_attributes: [
              :id,
              :amount,
              :product_id,
              :detail,
              :unit_price,
              :tax_rate,
              :tax,
              :subtotal,
              :position,
              :unit,
              :remaining_amount,
              :_destroy
           ]
      )
    end

    def set_information
      translation_key = case params[:order_type]
                          when 'purchase'  then 'view.orders.types.purchases'
                          when 'budget'    then 'view.orders.types.budgets'
                          else                  'activerecord.models.order.other'
                        end

      @information = { title: t(translation_key) }
    end

    # Form url for new/create methods.
    def new_form_information
      @information[:form_url] = orders_path(@order, order_type: params[:order_type])

      case params[:order_type]
        when 'purchase'
          @information[:subtitle] = t('view.orders.types.new_purchase')
          @information[:button_text] = t('view.orders.types.save_purchase')
        when 'budget'
          @information[:subtitle] = t('view.orders.types.new_budget')
          @information[:button_text] = t('view.orders.types.save_budget')
        else
          @information[:subtitle] = t('view.orders.types.new_sale')
          @information[:button_text] = t('view.orders.types.save_sale')
      end

      @information[:back_url] = back_path(@order)
    end

    # Form url for edit/update methods.
    def edit_form_information
      @information[:form_url] = order_path(@order, order_type: params[:order_type])

      case params[:order_type]
        when 'purchase'
          @information[:subtitle] = t('view.orders.types.edit_purchase', order_number: @order.number)
          @information[:button_text] = t('view.orders.types.save_purchase')
        when 'budget'
          @information[:subtitle] = t('view.orders.types.edit_budget', order_number: @order.number)
          @information[:button_text] = t('view.orders.types.save_budget')
        else
          @information[:subtitle] = t('view.orders.types.edit_sale', order_number: @order.number)
          @information[:button_text] = t('view.orders.types.save_sale')
      end

      @information[:back_url] = back_path(@order)
    end

    def back_path(order)
      case order
        when PurchaseOrder then purchases_path
        when BudgetOrder   then budgets_path
        else                    orders_path
      end
    end
end
