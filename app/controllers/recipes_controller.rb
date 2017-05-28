class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_product
  before_action :set_information

  # GET /recipes/1
  def show
    @information[:subtitle] = @recipe.name
  end

  # GET /recipes/new
  def new
    @recipe = @product.recipes.build
    @information[:subtitle] = t('view.recipes.new_title', product: @product.name)
    @information[:form_url] = product_recipes_path(@product)
  end

  # GET /recipes/1/edit
  def edit
    @information[:subtitle] = t('view.recipes.edit_title', product: @product.name)
    @information[:form_url] = product_recipe_path(@product, @recipe)
  end

  # POST /recipes
  def create
    @recipe = @product.recipes.build(recipe_params)
    @information[:subtitle] = t('view.recipes.new_title', product: @product.name)
    @information[:form_url] = product_recipes_path(@product)

    if @recipe.save
      redirect_to product_path(@product), notice: t('view.recipes.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /recipes/1
  def update
    @information[:subtitle] = t('view.recipes.edit_title', product: @product.name)
    @information[:form_url] = product_recipe_path(@product, @recipe)

    if @recipe.update(recipe_params)
      redirect_to product_path(@product), notice: t('view.recipes.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy
    redirect_to product_path(@product), notice: t('view.recipes.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    # Only allow a trusted parameter "white list" through.
    def recipe_params
      params.require(:recipe).permit(:name, :description, :product_id)
    end

    def set_information
      @information = { title: t('activerecord.models.product.other') }
    end
end
