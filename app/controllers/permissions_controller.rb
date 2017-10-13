class PermissionsController < ApplicationController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]
  before_action :set_parent
  before_action :set_information

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
      redirect_to [@parent, @permission], notice: t('view.permissions.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /permissions/1
  def update
    set_edit_form_information

    if @permission.update(permission_params)
      flash[:type] = 'primary'
      redirect_to [@parent, @permission], notice: t('view.permissions.correctly_updated')
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
      @information[:form_url] = if params[:certificate_id]
                                  certificate_permissions_path(@parent)
                                else
                                  firm_permissions_path(@parent)
                                end
    end

    # Information for edit/update methods.
    def set_edit_form_information
      @information[:subtitle] = t('view.permissions.edit_title')
      @information[:form_url] = if params[:certificate_id]
                                  certificate_permission_path(@parent)
                                else
                                  firm_permission_path(@parent)
                                end
    end

    def set_parent
      @certificate = params[:certificate_id] ? Certificate.find(params[:certificate_id]) : nil
      @firm        = params[:firm_id] ? Firm.find(params[:firm_id]) : nil
      @parent      = @certificate || @firm
    end
end
