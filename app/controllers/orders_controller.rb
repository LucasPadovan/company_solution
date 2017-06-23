class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /orders
  def index
    @orders = Order.all
  end

  # GET /orders/1
  def show
    @information[:subtitle] = @order.to_s
  end

  # GET /orders/new
  def new
    @order = Order.new
    @information[:subtitle] = t('view.orders.new_title')

    @order.number = (Order.last.try(:number) || 0) + 1
  end

  # GET /orders/1/edit
  def edit
    @information[:subtitle] = t('view.orders.edit_title')
  end

  # POST /orders
  def create
    @information[:subtitle] = t('view.orders.new_title')
    @order = Order.new(order_params)

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
    @information[:subtitle] = t('view.orders.edit_title')
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

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:number, :tracking_code, :type, :total, :subtotal, :taxes, :deliver_fee, :packaging_fee, :expected_deliver_from, :expected_deliver_to, :firm_id, :user_id, :contact_name, :date)
    end

    def set_information
      @information = { title: t('activerecord.models.order.other') }
    end
end
