class FirmsController < ApplicationController
  before_action :set_firm, only: [:show, :edit, :update, :destroy, :products_list]

  # GET /firms
  # GET /firms.json
  def index
    @firms = Firm.all
  end

  # GET /firms/1
  # GET /firms/1.json
  def show
    @information[:subtitle] = @firm.name
    @sells    = @firm.sells
    @buys     = @firm.buys
    @contacts = @firm.contacts
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


  def products_list
    products_list_information

    @trades = if params[:trade_type] === 'sells'
                Trade.where sold_by: @firm
              else
                Trade.where sold_to: @firm
              end

    respond_to do |format|
      format.html { render 'firms/products_list' }
      format.pdf do
        render  pdf: t(
                  'view.firms.buys.products_list_pdf_filename',
                  seller: t('app_name'),
                  buyer: @firm.name,
                  date: @date.strftime('%d%m%Y'),
                  time: Time.now.strftime('%H%M%S')
                ),
                template: 'firms/products_list',
                margin: {
                  top: 60,
                  # bottom: 60,
                },
                header: {
                  spacing: 50,
                  html: { template: 'shared/pdf/_company_logo.html.erb' },
                },
                footer: {
                  right: 'Pagina',
                  font_size: 9
                },
                encoding: 'UTF-8'
      end
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

    def products_list_information
      if params[:trade_type] === 'buys'
        @date = params[:header_date] ? Date.parse(params[:header_date]) : Date.today
        header_firm = params[:header_firm] || @firm.name
        contact = @firm.contacts.first.try(:name) || ''
        header_contact = params[:header_contact] || t('view.firms.buys.header_contact', contact: contact)

        @information[:header_date] = @date.strftime(t('date.formats.extended', place: 'Mendoza'))
        @information[:header_firm] = header_firm
        @information[:header_contact] = header_contact
        @information[:file_title] = t('view.firms.buys.products_list_pdf_title', firm: @firm.name)
      end

      @information[:subtitle] = t("view.firms.#{params[:trade_type]}.products_list", firm: @firm.name)
    end
end
