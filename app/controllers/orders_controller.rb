class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /orders
  def index
    @orders = filtered_orders
  end

  # GET /orders/1
  def show
    @information[:subtitle] = t('view.orders.show_title', order_number: @order.number)
  end

  # GET /orders/new
  def new
    @order = Order.new
    @information[:subtitle] = t('view.orders.new_title')

    @order.number = (Order.last.try(:number) || 0) + 1
    @order.date = Date.today
  end

  # GET /orders/1/edit
  def edit
    @information[:subtitle] = t('view.orders.edit_title', order_number: @order.number)
  end

  # POST /orders
  def create
    @information[:subtitle] = t('view.orders.new_title')
    @order = Order.new(order_params)

    @order.date = Date.today
    @order.user = current_user

    if @order.save
      flash[:type] = 'success'
      redirect_to @order, notice: t('view.orders.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    @information[:subtitle] = t('view.orders.edit_title', order_number: @order.number)

    if @order.update(order_params)
      flash[:type] = 'primary'
      redirect_to @order, notice: t('view.orders.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    flash[:type] = 'error'
    redirect_to orders_url, notice: t('view.orders.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def filtered_orders
      query = ''

      query += 'firm_id = :firm_id' if params[:firm_id].present?
      query += ' AND date = :date' if params[:date].present?


      Order.where(
          query,
          {
              firm_id: params[:firm_id],
              date: params[:date]
          }
      )
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(
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
      @information = { title: t('activerecord.models.order.other') }
    end
end
