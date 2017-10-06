class PermissionsController < ApplicationController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /permissions
  def index
    @permissions = Permission.all
  end

  # GET /permissions/1
  def show
    @information[:subtitle] = @permission.to_s
  end

  # GET /permissions/new
  def new
    @permission = Permission.new
    @information[:subtitle] = t('view.permissions.new_title')
  end

  # GET /permissions/1/edit
  def edit
    @information[:subtitle] = t('view.permissions.edit_title')
  end

  # POST /permissions
  def create
    @information[:subtitle] = t('view.permissions.new_title')
    @permission = Permission.new(permission_params)

    if @permission.save
      flash[:type] = 'success'
      redirect_to @permission, notice: t('view.permissions.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /permissions/1
  def update
    @information[:subtitle] = t('view.permissions.edit_title')
    if @permission.update(permission_params)
      flash[:type] = 'primary'
      redirect_to @permission, notice: t('view.permissions.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /permissions/1
  def destroy
    @permission.destroy
    flash[:type] = 'error'
    redirect_to permissions_url, notice: t('view.permissions.correctly_destroyed')
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
      @information = { title: t('activerecord.models.permission.other') }
    end
end
