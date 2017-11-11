class OrdersController < ApplicationController
  @@notices = {
      correctly_created: 'view.orders.correctly_created',
      correctly_updated: 'view.orders.correctly_updated',
      correctly_destroyed: 'view.orders.correctly_destroyed'
  }

  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_order_type, only: [:new, :create]
  before_action :set_information

  # GET /orders
  def index
    @orders = filtered_orders

    set_index_information
  end

  # GET /orders/1
  def show
    set_show_information
  end

  # GET /orders/new
  def new
    @order = @order_type.new

    set_new_form_information

    @order.number = (@order_type.last.try(:number) || 0) + 1
    @order.date = Date.today
  end

  # GET /orders/1/edit
  def edit
    set_edit_form_information
  end

  # POST /orders
  def create
    set_new_form_information
    @order = @order_type.new(order_params)

    @order.date = Date.today
    @order.user = current_user
    @order.statuses.build({
      status: OrderStatus.statuses[:open]
    })

    if @order.save
      flash[:type] = 'success'
      redirect_to redirect_path(@order), notice: t(@@notices[:correctly_created])
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    set_edit_form_information

    if @order.update(order_params)
      flash[:type] = 'primary'
      redirect_to redirect_path(@order), notice: t(@@notices[:correctly_updated])
    else
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    flash[:type] = 'error'
    redirect_to back_path, notice: t(@@notices[:correctly_destroyed])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_order_type
      @order_type = SaleOrder
    end

    def redirect_path(order)
      order_path(order)
    end

    def filtered_orders
      apply_filters(SaleOrder)
    end

    def apply_filters(order_type)
      should_filter_by_status = params[:status_id].present? && params[:status_id] != '0'
      should_get_pending_orders = params[:status_id].blank?
      query = []
      query_params = {}
      orders = order_type

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
      @information = { title: t('view.orders.title') }
    end

    # Information for index method
    def set_index_information
      @information[:new_title] = t('view.orders.new_title')
      @information[:show_path] = orders_path
      @information[:new_path] = new_order_path
    end

    # Information for show method
    def set_show_information
      @information[:subtitle] = t('view.orders.show_title', order_number: @order.number)
      @information[:edit_path] = edit_order_path(@order)
      @information[:back_path] = back_path
      @information[:status] = @order.get_permissions_status
    end

    # Information for new/create methods.
    def set_new_form_information
      @information[:form_url] = orders_path(@order)
      @information[:subtitle] = t('view.orders.new_title')
      @information[:button_text] = t('view.orders.save')
      @information[:back_path] = back_path
    end

    # Information for edit/update methods.
    def set_edit_form_information
      @information[:form_url] = order_path(@order)
      @information[:subtitle] = t('view.orders.edit_title', order_number: @order.number)
      @information[:button_text] = t('view.orders.save')
      @information[:back_path] = orders_path
    end

    def back_path
      orders_path
    end
end
