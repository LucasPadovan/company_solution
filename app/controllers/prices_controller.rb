class PricesController < ApplicationController
  before_action :set_price, only: [:edit, :update, :destroy]
  before_action :set_trade
  before_action :set_information

  after_action :update_trade, only: [:create, :update]

  # GET /prices
  def index
    @prices = @trade.prices.all
  end

  # GET /prices/new
  def new
    @price = @trade.prices.new
    @information[:subtitle] = t('view.prices.new_title')
  end

  # GET /prices/1/edit
  def edit
    @information[:subtitle] = t('view.prices.edit_title')
  end

  # POST /prices
  def create
    @information[:subtitle] = t('view.prices.new_title')
    @price = @trade.prices.new(price_params)

    if @price.save
      flash[:type] = 'success'
      redirect_to return_path(params[:origin]), notice: t('view.prices.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /prices/1
  def update
    @information[:subtitle] = t('view.prices.edit_title')
    if @price.update(price_params)
      flash[:type] = 'primary'
      redirect_to return_path(params[:origin]), notice: t('view.prices.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /prices/1
  def destroy
    @price.destroy
    flash[:type] = 'error'
    redirect_to product_path(@trade.product), notice: t('view.prices.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price
      @price = Price.find(params[:id])
    end

    def set_trade
      @trade = Trade.find(params[:trade_id])
    end

    def update_trade
      @trade.from ||= @price.valid_from
      @trade.to ||= @price.valid_to

      @trade.save
    end

    def return_path(origin)
      if origin === 'product'
        product_path(@trade.product)
      elsif origin === 'firm'
        firm_path(@trade.sold_to || @trade.sold_by)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def price_params
      params.require(:price).permit(:trade_id, :price, :min_quantity, :valid_from, :valid_to, :currency, :available, :tax_rate)
    end

    def set_information
      @information = { title: t('activerecord.models.price.other') }
    end
end
