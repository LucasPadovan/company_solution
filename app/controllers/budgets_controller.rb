class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /budgets
  def index
    @budgets = filtered_budgets

    set_index_information
  end

  # GET /budgets/1
  def show
    set_show_information
  end

  # GET /budgets/new
  def new
    @budget = Budget.new

    set_new_form_information

    @budget.number = (Budget.last.try(:number) || 0) + 1
    @budget.date = Date.today
  end

  # GET /budgets/1/edit
  def edit
    set_edit_form_information
  end

  # POST /budgets
  def create
    set_new_form_information
    @budget = Budget.new(budget_params)

    @budget.date = Date.today
    @budget.user = current_user

    if @budget.save
      flash[:type] = 'success'
      redirect_to budgets_path, notice: t('view.budgets.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /budgets/1
  def update
    set_edit_form_information

    if @budget.update(budget_params)
      flash[:type] = 'primary'
      redirect_to redirect_path(@budget), notice: t('view.budgets.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /budgets/1
  def destroy
    @budget.destroy
    flash[:type] = 'error'
    redirect_to back_path, notice: t('view.budgets.correctly_destroyed')
  end

  private
  def set_budget
    @budget = Budget.find(params[:id])
  end

  def redirect_path(budget)
    budget_path(budget)
  end

  def set_information
    @information = { title: t('view.budgets.title') }
  end

  # Information for index method
  def set_index_information
    @information[:new_title] = t('view.budgets.new_title')
    @information[:new_path] = new_budget_path
  end

  # Information for show method
  def set_show_information
    @information[:subtitle] = t('view.budgets.show_title', budget_number: @budget.number)
    @information[:edit_path] = edit_budget_path(@budget)
    @information[:back_path] = back_path
    @information[:status] = @budget.get_permissions_status
  end

  # Information for new/create methods.
  def set_new_form_information
    @information[:form_url] = budgets_path(@budget)
    @information[:subtitle] = t('view.budgets.new_title')
    @information[:button_text] = t('view.budgets.save')
    @information[:back_path] = back_path
  end

  # Information for edit/update methods.
  def set_edit_form_information
    @information[:form_url] = budget_path(@budget)
    @information[:subtitle] = t('view.budgets.edit_title', budget_number: @budget.number)
    @information[:button_text] = t('view.budgets.save')
    @information[:back_path] = back_path
  end

  def back_path
    budgets_path
  end

  def filtered_budgets
    query = []
    query_params = {}
    budgets = Budget

    if params[:firm_id].present?
      query << ['firm_id = :firm_id']
      query_params[:firm_id] = params[:firm_id]
    end

    if params[:date].present?
      query << ['date = :date']
      query_params[:date] = params[:date]
    end

    if query.length > 0
      query = query.join(' AND ')

      budgets = budgets.where(query, query_params)
    end

    budgets.date_asc
  end

  # Only allow a trusted parameter "white list" through.
  def budget_params
    params.require(:budget).permit(
        :id,
        :firm_id,
        :number,
        :date,
        :from,
        :to,
        :destinatary,
        :contact,
        :title,
        :header_image,
        :body_image,
        :user_id,

        lines_attributes: [
            :id,
            :product_id,
            :unit_price,
            :currency,
            :tax_rate,
            :subtotal,
            :unit,
            :position,
            :price_change,
            :_destroy
        ]
    )
  end
end