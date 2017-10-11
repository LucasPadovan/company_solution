class CertificatesController < ApplicationController
  before_action :set_certificate, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /certificates
  def index
    @certificates = Certificate.all
  end

  # GET /certificates/1
  def show
    @information[:subtitle] = @certificate.name
  end

  # GET /certificates/new
  def new
    @certificate = Certificate.new
    @information[:subtitle] = t('view.certificates.new_title')
  end

  # GET /certificates/1/edit
  def edit
    @information[:subtitle] = t('view.certificates.edit_title')
  end

  # POST /certificates
  def create
    @information[:subtitle] = t('view.certificates.new_title')
    @certificate = Certificate.new(certificate_params)

    if @certificate.save
      flash[:type] = 'success'
      redirect_to @certificate, notice: t('view.certificates.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /certificates/1
  def update
    @information[:subtitle] = t('view.certificates.edit_title')
    if @certificate.update(certificate_params)
      flash[:type] = 'primary'
      redirect_to @certificate, notice: t('view.certificates.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /certificates/1
  def destroy
    @certificate.destroy
    flash[:type] = 'error'
    redirect_to certificates_url, notice: t('view.certificates.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate
      @certificate = Certificate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def certificate_params
      params.require(:certificate).permit(
          :name,
          :description,
          :website,
          :email,
          :wait_time,
          :notes,

          details_attributes: [
              :id,
              :product_id,
              :_destroy
          ]
      )
    end

    def set_information
      @information = { title: t('activerecord.models.certificate.other') }
    end
end
