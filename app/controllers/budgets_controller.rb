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
    @budget = if params[:firm_id].present?
                firm = Firm.find(params[:firm_id])

                firm.budgets.new
              else
                 Budget.new
              end

    @created_date = format_date(@budget.date)
    @valid_from = params[:valid_from].present? ? (Date.parse(params[:valid_from])) : Date.today

    set_new_form_information

    @budget.title = t('view.firms.buys.products_list_title', date: l(@valid_from, format: t('date.formats.long')))
  end

  # GET /budgets/1/edit
  def edit
    set_edit_form_information

    @created_date = I18n.l(@budget.date, format: I18n.t('date.formats.long'))
  end

  # POST /budgets
  def create
    @budget = Budget.new(budget_params)

    @budget.user = current_user
    @budget.date = Date.parse(format_date(budget_params['date']))

    set_new_form_information
    if @budget.save
      flash[:type] = 'success'
      redirect_to return_path, notice: t('view.budgets.correctly_created')
    else
      @created_date = format_date(budget_params['date'])
      @valid_from = params[:valid_from].present? ? (Date.parse(params[:valid_from])) : Date.today

      render :new
    end
  end

  # PATCH/PUT /budgets/1
  def update
    set_edit_form_information

    budget_params_copy = budget_params
    budget_params_copy['date'] = parse_date(budget_params['date'])

    if @budget.update(budget_params_copy)
      flash[:type] = 'primary'
      redirect_to return_path, notice: t('view.budgets.correctly_updated')
    else
      @created_date = format_date(budget_params['date'])

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

  def set_information
    @information = { title: t('view.budgets.title') }
  end

  # Information for index method
  def set_index_information
    @information[:new_title] = t('view.budgets.new_title')
    @information[:new_path] = if params[:firm_id]
                                new_firm_budget_path(params[:firm_id])
                              else
                                new_budget_path
                              end
  end

  # Information for show method
  def set_show_information
    @information[:subtitle] = t('view.budgets.show_title', budget_number: @budget.number)
    @information[:edit_path] = if params[:firm_id]
                                 edit_firm_budget_path(params[:firm_id], @budget)
                               else
                                 edit_budget_path(@budget)
                               end

    @information[:back_path] = back_path
  end

  # Information for new/create methods.
  def set_new_form_information
    @information[:form_url] = if params[:firm_id]
                                firm_budgets_path(params[:firm_id], @budget)
                              else
                                budgets_path(@budget)
                              end
    @information[:subtitle] = t('view.budgets.new_title')
    @information[:button_text] = t('view.budgets.save')
    @information[:back_path] = back_path
  end

  # Information for edit/update methods.
  def set_edit_form_information
    @information[:form_url] = if params[:firm_id]
                                firm_budget_path(params[:firm_id], @budget)
                              else
                                budget_path(@budget)
                              end
    @information[:subtitle] = t('view.budgets.edit_title', budget_number: @budget.number)
    @information[:button_text] = t('view.budgets.save')
    @information[:back_path] = params[:firm_id].present? ? firm_budget_path(params[:firm_id], @budget) : @budget
  end

  def back_path
    params[:firm_id].present? ? firm_budgets_path(params[:firm_id], @budget) : budgets_path
  end

  def return_path
    params[:firm_id].present? ? firm_budget_path(params[:firm_id], @budget) : @budget
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

  def parse_date(raw_date)
    begin
      Date.parse(raw_date)
    rescue
      # TODO: add errors
      Date.today
    end
  end

  def format_date(raw_date)
    _date = parse_date(raw_date)

    l(_date, format: I18n.t('date.formats.long'))
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
            :unit,
            :currency,
            :tax_rate,
            :position,
            :price_change,
            :_destroy
        ]
    )
  end
end