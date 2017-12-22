class MealCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin

  def index
    @meal_categories = MealCategory.all
  end

  def show
    @meal_category = MealCategory.find(params[:id])
  end

  def new
    @meal_category = MealCategory.new
  end

  def create
    @meal_category = MealCategory.new(meal_category_params)

    if @meal_category.save
      redirect_to @meal_category
    else
      render 'new'
    end
  end

  private
  def meal_category_params
    params.require(:meal_category).permit(:name)
  end
end
