class TradesController < ApplicationController
  before_action :set_trade, only: [:edit, :update, :destroy]
  before_action :set_parent, except: [:find_trade]
  before_action :set_information

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

  def find_trade
    # Should find the correct trade, its available price, and return the unit, unit price and imp%
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
                  Firm.find(params[:firm_id])
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
        if params[:trade_type] == 'sells'
          @trade.sold_by = @parent.id
        elsif params[:trade_type] == 'buys'
          @trade.sold_to = @parent.id
        end
      elsif params[:product_id]
        @trade.product_id = @parent.id
      end
    end

    # Form url for new/create methods.
    def new_form_url
      if params[:firm_id]
        @information[:form_url] = firm_trades_path(@parent, trade_type: params[:trade_type])
        @information[:back_url] = firm_path(@parent)
        @information[:subtitle] = if params[:trade_type] == 'sells'
                                    t('view.trades.new_trade_sold_by_firm_title', firm: @parent.name)
                                  elsif params[:trade_type] == 'buys'
                                    t('view.trades.new_trade_sold_to_firm_title', firm: @parent.name)
                                  end
      elsif params[:product_id]
        @information[:form_url] = product_trades_path(@parent, trade_type: params[:trade_type])
        @information[:back_url] = product_path(@parent)
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
        @information[:back_url] = firm_path(@parent)
      elsif params[:product_id]
        @information[:form_url] = product_trade_path(@parent, @trade)
        @information[:back_url] = product_path(@parent)
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
end
