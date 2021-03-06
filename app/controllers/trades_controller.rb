class TradesController < ApplicationController
  before_action :set_trade, only: [:edit, :update, :destroy]
  before_action :set_parent, except: [:find_product]
  before_action :set_information

  def index
    @firm = @parent
    @trades = if params[:trade_type] === 'sells'
                @parent.sells
              else
                @parent.buys
              end

    set_index_filters

    index_information
  end

  # GET /trades/new
  def new
    @trade = Trade.new

    bind_parent

    new_form_url
  end

  # GET /trades/1/edit
  def edit
    @information[:subtitle] = t('view.trades.edit_title')

    edit_form_url
  end

  # POST /trades
  def create
    @trade = Trade.new(trade_params)

    bind_parent

    if @trade.save
      flash[:type] = 'success'
      redirect_to return_url, notice: t('view.trades.correctly_created')
    else
      new_form_url

      render :new
    end
  end

  # PATCH/PUT /trades/1
  def update
    @information[:subtitle] = t('view.trades.edit_title')
    if @trade.update(trade_params)
      flash[:type] = 'primary'
      redirect_to return_url, notice: t('view.trades.correctly_updated')
    else
      edit_form_url

      render :edit
    end
  end

  # DELETE /trades/1
  def destroy
    @trade.destroy
    flash[:type] = 'error'
    redirect_to return_url, notice: t('view.trades.correctly_destroyed')
  end

  def find_product
    trades = if params[:order_type] === 'purchases'
               Trade.where sold_by: params[:firm], product_id: params[:product]
             else
               Trade.where sold_to: params[:firm], product_id: params[:product]
             end
    trade = trades.first

    if trade
      if available_price = trade.available_price
        tax_rate = available_price.tax_rate
        unit_price = available_price.price
      end

      if product = trade.product
        unit = product.unit
      end
    else
      unit = Product.find(params[:product]).unit
    end

    product_detail = {
        currency: available_price.currency,
        tax_rate: tax_rate || '21',
        unit: unit || 'kg',
        unit_price: unit_price || '00',
    }

    respond_to do |format|
      format.json { render json: product_detail.to_json }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade
      @trade = Trade.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def trade_params
      params.require(:trade).permit(:product_id, :sold_by, :sold_to, :from, :to)
    end
  
    def set_parent
      @parent = if params[:product_id]
                  Product.find(params[:product_id])
                else
                  Firm.find(params[:firm_id] || params[:id])
                end
    end

    def set_information
      title = if params[:product_id]
                t('activerecord.models.product.other')
              else
                t('activerecord.models.firm.other')
              end
      @information = { title: title }
    end

    # For new/create methods it is mandatory to set who is selling/buying what product.
    def bind_parent
      if params[:firm_id]
        if params[:trade_type] === 'sells'
          @trade.sold_by = @parent.id
        elsif params[:trade_type] === 'buys'
          @trade.sold_to = @parent.id
        end
      elsif params[:product_id]
        @trade.product_id = @parent.id
      end
    end

    # Form url for index.
    def index_information
      @information[:show_path] = firm_trades_path(@parent)
      @information[:back_path] = firm_path(@parent)
      @information[:subtitle] = if params[:trade_type] == 'sells'
                                  t('view.trades.new_trade_sold_by_firm_title', firm: @parent.name)
                                elsif params[:trade_type] == 'buys'
                                  t('view.trades.new_trade_sold_to_firm_title', firm: @parent.name)
                                end
    end

    # Form url for new/create methods.
    def new_form_url
      if params[:firm_id]
        @information[:form_url] = firm_trades_path(@parent, trade_type: params[:trade_type])
        @information[:back_path] = firm_path(@parent)
        @information[:subtitle] = if params[:trade_type] == 'sells'
                                    t('view.trades.new_trade_sold_by_firm_title', firm: @parent.name)
                                  elsif params[:trade_type] == 'buys'
                                    t('view.trades.new_trade_sold_to_firm_title', firm: @parent.name)
                                  end
      elsif params[:product_id]
        @information[:form_url] = product_trades_path(@parent, trade_type: params[:trade_type])
        @information[:back_path] = product_path(@parent)
        @information[:subtitle] = if params[:trade_type] == 'sells'
                                    t('view.trades.new_product_traded_by_title', product: @parent.name)
                                  elsif params[:trade_type] == 'buys'
                                    t('view.trades.new_product_traded_to_title', product: @parent.name)
                                  end
      end
    end

    # Form url for edit/update methods.
    def edit_form_url
      if params[:firm_id]
        @information[:form_url] = firm_trade_path(@parent, @trade)
        @information[:back_path] = firm_path(@parent)
      elsif params[:product_id]
        @information[:form_url] = product_trade_path(@parent, @trade)
        @information[:back_path] = product_path(@parent)
      end
    end

    # Since a "show" view won't be necessary for now, we return to the parent show.
    def return_url
      if params[:firm_id]
        firm_path(@parent)
      elsif params[:product_id]
        product_path(@parent)
      end
    end

    def set_index_filters
      if params[:filter_product_name]
        @trades = @trades.joins(:product)
        @trades = @trades.where('lower(products.name) LIKE :name', name: "%#{params[:filter_product_name].downcase}%")
      end
    end
end
