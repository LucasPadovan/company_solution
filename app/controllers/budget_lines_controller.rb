class BudgetLinesController < ApplicationController
  before_action :set_budget_line, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /budget_lines
  def index
    @budget_lines = BudgetLine.all
  end

  # GET /budget_lines/1
  def show
    @information[:subtitle] = @budget_line.to_s
  end

  # GET /budget_lines/new
  def new
    @budget_line = BudgetLine.new
    @information[:subtitle] = t('view.budget_lines.new_title')
  end

  # GET /budget_lines/1/edit
  def edit
    @information[:subtitle] = t('view.budget_lines.edit_title')
  end

  # POST /budget_lines
  def create
    @information[:subtitle] = t('view.budget_lines.new_title')
    @budget_line = BudgetLine.new(budget_line_params)

    if @budget_line.save
      flash[:type] = 'success'
      redirect_to @budget_line, notice: t('view.budget_lines.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /budget_lines/1
  def update
    @information[:subtitle] = t('view.budget_lines.edit_title')
    if @budget_line.update(budget_line_params)
      flash[:type] = 'primary'
      redirect_to @budget_line, notice: t('view.budget_lines.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /budget_lines/1
  def destroy
    @budget_line.destroy
    flash[:type] = 'error'
    redirect_to budget_lines_url, notice: t('view.budget_lines.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_line
      @budget_line = BudgetLine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def budget_line_params
      params.require(:budget_line).permit(:budget_id, :product_id, :unit_price, :currency, :tax_rate, :unit, :position, :price_change)
    end

    def set_information
      @information = { title: t('activerecord.models.budget_line.other') }
    end
end
