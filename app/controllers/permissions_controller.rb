class PermissionsController < ApplicationController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]
  before_action :set_parent
  before_action :set_information

  def index
    @permissions = @parent.permissions

    @permissions = @permissions.where(firm_id: params[:filter_firm_id]) if params[:filter_firm_id].present?
    @permissions = @permissions.where(certificate_id: params[:filter_certificate_id]) if params[:filter_certificate_id].present?

    if @no_firm
      @permissions = @permissions.without_firm
    else
      @permissions = @permissions.with_firm
    end
  end

  # GET /permissions/1
  def show
    @information[:subtitle] = t('view.permissions.show_title')
  end

  # GET /permissions/new
  def new
    @permission = @parent.permissions.build

    set_new_form_information
  end

  # GET /permissions/1/edit
  def edit
    set_edit_form_information
  end

  # POST /permissions
  def create
    @permission = @parent.permissions.new(permission_params)

    set_new_form_information

    if @permission.save
      flash[:type] = 'success'
      redirect_to [@parent, @permission, no_firm: @no_firm], notice: t('view.permissions.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /permissions/1
  def update
    set_edit_form_information

    if @permission.update(permission_params)
      flash[:type] = 'primary'
      redirect_to [@parent, @permission, no_firm: @no_firm], notice: t('view.permissions.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /permissions/1
  def destroy
    @permission.destroy
    flash[:type] = 'error'
    redirect_to @parent, notice: t('view.permissions.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def permission_params
      params.require(:permission).permit(:from_date, :to_date, :certificate_id, :firm_id, :contact)
    end

    def set_information
      @information             = { title: t('activerecord.models.permission.other') }
      @information[:back_path] = @parent
    end

    # Information for new/create methods.
    def set_new_form_information
      @information[:subtitle] = t('view.permissions.new_title')
      @information[:form_url] = [@parent, 'permissions', no_firm: @no_firm]
    end

    # Information for edit/update methods.
    def set_edit_form_information
      @information[:subtitle] = t('view.permissions.edit_title')
      @information[:form_url] = [@parent, 'permission', no_firm: @no_firm]
    end

    def set_parent
      # if params[:no_firm] has 'false', comparing to 'true' as string will return a proper boolean with the real value
      @no_firm     = params[:no_firm] === 'true'
      @certificate = params[:certificate_id] ? Certificate.find(params[:certificate_id]) : nil
      @firm        = params[:firm_id] ? Firm.find(params[:firm_id]) : nil
      @parent      = @certificate || @firm
    end
end
