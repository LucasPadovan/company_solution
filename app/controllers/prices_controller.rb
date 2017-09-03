class PricesController < ApplicationController
  before_action :set_price, only: [:destroy, :set_as_available]
  before_action :set_trade
  before_action :set_information, except: :index

  after_action :update_trade, only: [:create]

  # GET /prices
  def index
    @prices = @trade.prices.all

    if params[:origin] === 'product'
      @information = { title: t('activerecord.models.product.other') }

      firm = @trade.buyer || @trade.seller
      subtitle = if @trade.buyer
                   'view.prices.buyer_product_index_title'
                 else
                   'view.prices.seller_product_index_title'
                 end

      @information[:subtitle] = t(subtitle, firm: firm.name, product: @trade.product.name)
      @information[:return_path] = product_path(@trade.product)
      @information[:origin] = 'product'
    end

    if params[:origin] === 'firm'
      @information = { title: t('activerecord.models.firm.other') }

      firm = @trade.buyer || @trade.seller
      subtitle = if @trade.buyer
                   'view.prices.buyer_firm_index_title'
                 else
                   'view.prices.seller_firm_index_title'
                 end

      @information[:subtitle] = t(subtitle, firm: firm.name, product: @trade.product.name)
      @information[:return_path] = firm_path(@trade.seller || @trade.buyer)
      @information[:origin] = 'firm'
    end
  end

  # GET /prices/new
  def new
    @price = @trade.prices.new
    @information[:subtitle] = t('view.prices.new_title')
  end

  # POST /prices
  def create
    @information[:subtitle] = t('view.prices.new_title')
    @price = @trade.prices.new(price_params)

    if @price.save
      flash[:type] = 'success'
      redirect_to return_path(params[:origin]), notice: t('view.prices.correctly_created')
    else
      # render :new  js alert error that shows form errors.
    end
  end

  # DELETE /prices/1
  def destroy
    @price.destroy

    notice = if @trade.prices.availables.empty?
               t('view.prices.correctly_destroyed_and_no_availables')
             else
               t('view.prices.correctly_destroyed')
             end

    flash[:type] = 'error'
    redirect_to trade_prices_path(@trade, origin: params[:origin]), notice: notice
  end

  def set_as_available
    if @price.set_as_available
      flash[:type] = 'success'
      redirect_to trade_prices_path(@trade, origin: params[:origin]), notice: t('view.prices.correctly_updated')
    end
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
      should_update_from = @price.valid_from && (@trade.from && @trade.from > @price.valid_from) || !@trade.from
      should_update_to   = @price.valid_to   && (@trade.to && @trade.to > @price.valid_to)       || !@trade.to

      @trade.from = @price.valid_from if should_update_from
      @trade.to   = @price.valid_to   if should_update_to

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
