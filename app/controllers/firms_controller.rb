class FirmsController < ApplicationController
  before_action :set_firm, only: [:show, :edit, :update, :destroy]

  # GET /firms
  # GET /firms.json
  def index
    @firms = Firm.all
  end

  # GET /firms/1
  # GET /firms/1.json
  def show
    today = Date.today

    @information[:subtitle] = @firm.name
    @sells       = @firm.sells
    @buys        = @firm.buys
    @contacts    = @firm.contacts
    @permissions = @firm.permissions.only_valids

    @modal_errors = JSON.parse(params[:modal_errors]) if params[:modal_errors]
  end

  # GET /firms/new
  def new
    @firm = Firm.new
    @information[:subtitle] = t('view.firms.new_title')
  end

  # GET /firms/1/edit
  def edit
    @information[:subtitle] = t('view.firms.edit_title', firm: @firm.name)
  end

  # POST /firms
  # POST /firms.json
  def create
    @firm = Firm.new(firm_params)

    respond_to do |format|
      if @firm.save
        flash[:type] = 'success'
        format.html { redirect_to @firm, notice: t('view.firms.correctly_created') }
        format.json { render :show, status: :created, location: @firm }
      else
        format.html { render :new }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /firms/1
  # PATCH/PUT /firms/1.json
  def update
    respond_to do |format|
      if @firm.update(firm_params)
        flash[:type] = 'primary'
        format.html { redirect_to @firm, notice: t('view.firms.correctly_updated') }
        format.json { render :show, status: :ok, location: @firm }
      else
        format.html { render :edit }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /firms/1
  # DELETE /firms/1.json
  def destroy
    @firm.destroy
    flash[:type] = 'error'
    respond_to do |format|
      format.html { redirect_to firms_url, notice: t('view.firms.correctly_destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firm
      @firm = Firm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def firm_params
      params.require(:firm).permit(:name, :cuit, :afip_condition, :opens_at, :closes_at)
    end
end
