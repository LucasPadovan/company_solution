class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /trades
  def index
    @trades = Trade.all
  end

  # GET /trades/1
  def show
    @information[:subtitle] = @trade.to_s
  end

  # GET /trades/new
  def new
    @trade = Trade.new
    @information[:subtitle] = t('view.trades.new_title')
  end

  # GET /trades/1/edit
  def edit
    @information[:subtitle] = t('view.trades.edit_title')
  end

  # POST /trades
  def create
    @information[:subtitle] = t('view.trades.new_title')
    @trade = Trade.new(trade_params)

    if @trade.save
      flash[:type] = 'success'
      redirect_to @trade, notice: t('view.trades.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /trades/1
  def update
    @information[:subtitle] = t('view.trades.edit_title')
    if @trade.update(trade_params)
      flash[:type] = 'primary'
      redirect_to @trade, notice: t('view.trades.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /trades/1
  def destroy
    @trade.destroy
    flash[:type] = 'error'
    redirect_to trades_url, notice: t('view.trades.correctly_destroyed')
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

    def set_information
      @information = { title: t('activerecord.models.trade.other') }
    end

end
