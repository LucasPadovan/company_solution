class OrderStatusesController < ApplicationController
  before_action :set_order_status, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /order_statuses
  def index
    @order_statuses = OrderStatus.all
  end

  # GET /order_statuses/1
  def show
    @information[:subtitle] = @order_status.to_s
  end

  # GET /order_statuses/new
  def new
    @order_status = OrderStatus.new
    @information[:subtitle] = t('view.order_statuses.new_title')
  end

  # GET /order_statuses/1/edit
  def edit
    @information[:subtitle] = t('view.order_statuses.edit_title')
  end

  # POST /order_statuses
  def create
    @information[:subtitle] = t('view.order_statuses.new_title')
    @order_status = OrderStatus.new(order_status_params)

    if @order_status.save
      flash[:type] = 'success'
      redirect_to @order_status, notice: t('view.order_statuses.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /order_statuses/1
  def update
    @information[:subtitle] = t('view.order_statuses.edit_title')
    if @order_status.update(order_status_params)
      flash[:type] = 'primary'
      redirect_to @order_status, notice: t('view.order_statuses.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /order_statuses/1
  def destroy
    @order_status.destroy
    flash[:type] = 'error'
    redirect_to order_statuses_url, notice: t('view.order_statuses.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_status
      @order_status = OrderStatus.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_status_params
      params.require(:order_status).permit(:status, :order_id, :detail)
    end

    def set_information
      @information = { title: t('activerecord.models.order_status.other') }
    end
end
