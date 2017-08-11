class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_order_type, only: [:new, :create]
  before_action :set_information

  # GET /orders
  def index
    @orders = filtered_orders

    translation_key = case params[:order_type]
                        when 'purchase'  then 'view.orders.types.new_purchase'
                        when 'budget'    then 'view.orders.types.new_budget'
                        else                  'view.orders.new_title'
                      end

    @information[:new_title] = t(translation_key)
  end

  # GET /orders/1
  def show
    @information[:subtitle] = t('view.orders.show_title', order_number: @order.number)
    @information[:back_url] = case params[:order_type]
                                when 'purchase'  then purchases_path
                                when 'budget'    then budgets_path
                                else                  orders_path
                              end
  end

  # GET /orders/new
  def new
    @order = @order_type.new

    new_form_information

    @order.number = (@order_type.last.try(:number) || 0) + 1
    @order.date = Date.today
  end

  # GET /orders/1/edit
  def edit
    edit_form_information
  end

  # POST /orders
  def create
    @information[:subtitle] = t('view.orders.new_title')
    @order = @order_type.new(order_params)

    @order.date = Date.today
    @order.user = current_user
    @order.statuses.build({
      status: OrderStatus.statuses[:open]
    })

    if @order.save
      flash[:type] = 'success'
      redirect_to order_path(@order, order_type: params[:order_type]), notice: t('view.orders.correctly_created')
    else
      new_form_information
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    @information[:subtitle] = t('view.orders.edit_title', order_number: @order.number)

    if @order.update(order_params)
      flash[:type] = 'primary'
      redirect_to order_path(@order, order_type: params[:order_type]), notice: t('view.orders.correctly_updated')
    else
      edit_form_information
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    flash[:type] = 'error'
    redirect_to orders_url, notice: t('view.orders.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_order_type
      @order_type = case params[:order_type]
                      when 'purchase' then PurchaseOrder
                      when 'budget'   then BudgetOrder
                      else                 SaleOrder
                    end
    end

    def filtered_orders
      query = []

      query << ['firm_id = :firm_id'] if params[:firm_id].present?
      query << ['date = :date'] if params[:date].present?
      query << ['order_statuses.status = :status_id'] if params[:status_id].present?

      orders =  if query.length > 0
                  query = query.join(' AND ')

                  Order.joins(:statuses).where(
                      query,
                      {
                          firm_id: params[:firm_id],
                          date: params[:date],
                          status_id: params[:status_id]
                      }
                  )
                else
                  Order.pending
                end

      # If this changes, check the routes.rb file.
      orders = case params[:order_type]
                 when 'purchase'  then orders.purchases
                 when 'budget'    then orders.budgets
                 else                  orders.sales
               end

      orders.date_asc
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(
          :id,
          :firm_id,
          :number,
          :date,
          :contact_name,
          :taxes,
          :deliver_fee,
          :packaging_fee,
          :subtotal,
          :total,
          :currency,
          :expected_deliver_from,
          :expected_deliver_to,
          :tracking_code,
          :detail,
          :type,
          :user_id,

          lines_attributes: [
              :id,
              :amount,
              :product_id,
              :detail,
              :unit_price,
              :tax_rate,
              :tax,
              :subtotal,
              :position,
              :unit,
              :remaining_amount,
              :_destroy
           ]
      )
    end

    def set_information
      translation_key = case params[:order_type]
                          when 'purchase'  then 'view.orders.types.purchases'
                          when 'budget'    then 'view.orders.types.budgets'
                          else                  'activerecord.models.order.other'
                        end

      @information = { title: t(translation_key) }
    end

    # Form url for new/create methods.
    def new_form_information
      @information[:subtitle] = t('view.orders.new_title')
      @information[:form_url] = orders_path(@order)
      @information[:back_url] = case params[:order_type]
                                  when 'purchase'  then purchases_path
                                  when 'budget'    then budgets_path
                                  else                  orders_path
                                end
    end

    # Form url for edit/update methods.
    def edit_form_information
      @information[:subtitle] = t('view.orders.edit_title', order_number: @order.number)
      @information[:form_url] = order_path(@order)
      @information[:back_url] = case params[:order_type]
                                  when 'purchase'  then purchases_path
                                  when 'budget'    then budgets_path
                                  else                  orders_path
                                end
    end
end
