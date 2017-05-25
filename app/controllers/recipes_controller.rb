class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_information

  # GET /recipes
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1
  def show
    @information[:subtitle] = @recipe.to_s
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @information[:subtitle] = t('view.recipes.new_title')
  end

  # GET /recipes/1/edit
  def edit
    @information[:subtitle] = t('view.recipes.edit_title', recipe: @recipe)
  end

  # POST /recipes
  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: t('view.recipes.correctly_created')
    else
      render :new
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: t('view.recipes.correctly_updated')
    else
      render :edit
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: t('view.recipes.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def recipe_params
      params.require(:recipe).permit(:name, :description, :product_id)
    end

    def set_information
      @information = { title: t('activerecord.models.recipe.other') }
    end
end
