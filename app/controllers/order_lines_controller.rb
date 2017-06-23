class OrderLinesController < ApplicationController
  before_action :set_order_line, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /order_lines
  def index
    @order_lines = OrderLine.all
  end

  # GET /order_lines/1
  def show
    @information[:subtitle] = @order_line.to_s
  end

  # GET /order_lines/new
  def new
    @order_line = OrderLine.new
    @information[:subtitle] = t('view.order_lines.new_title')
  end

  # GET /order_lines/1/edit
  def edit
    @information[:subtitle] = t('view.order_lines.edit_title')
  end

  # POST /order_lines
  def create
    @information[:subtitle] = t('view.order_lines.new_title')
    @order_line = OrderLine.new(order_line_params)

    if @order_line.save
      flash[:type] = 'success'
      redirect_to @order_line, notice: t('view.order_lines.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /order_lines/1
  def update
    @information[:subtitle] = t('view.order_lines.edit_title')
    if @order_line.update(order_line_params)
      flash[:type] = 'primary'
      redirect_to @order_line, notice: t('view.order_lines.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /order_lines/1
  def destroy
    @order_line.destroy
    flash[:type] = 'error'
    redirect_to order_lines_url, notice: t('view.order_lines.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_line
      @order_line = OrderLine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_line_params
      params.require(:order_line).permit(:order_id, :amount, :product_id, :unit_price, :subtotal, :tax_rate, :tax, :remaining_amount, :position)
    end

    def set_information
      @information = { title: t('activerecord.models.order_line.other') }
    end
end
