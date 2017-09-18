class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    respond_to do |format|
      format.html do
        @user = @product.user
        @buyers = @product.trades.only_buyers
        @sellers = @product.trades.only_sellers
        @recipes = @product.recipes

        @modal_errors = JSON.parse(params[:modal_errors]) if params[:modal_errors]

        @information[:subtitle] = @product.name
        render 'products/show'
      end
      format.json { @product.to_json }
    end
  end

  # GET /products/new
  def new
    @product = Product.new

    new_form_information
  end

  # GET /products/1/edit
  def edit
    edit_form_information
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user = current_user

    respond_to do |format|
      if @product.save
        flash[:type] = 'success'
        format.html { redirect_to product_path(@product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html do
          new_form_information

          render :new
        end
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        flash[:type] = 'primary'
        format.html { redirect_to product_path(@product), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html do
          edit_form_information

          render :edit
        end
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    flash[:type] = 'error'

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :area, :type, :unit, :initial_stock, :current_stock)
    end

    # Form url for new/create methods.
    def new_form_information
      @information[:subtitle] = t('view.products.new_title')
      @information[:form_url] = products_path
    end

    # Form url for edit/update methods.
    def edit_form_information
      @information[:subtitle] = t('view.products.edit_title', product: @product.name)
      @information[:form_url] = product_path(@product)
    end
end
