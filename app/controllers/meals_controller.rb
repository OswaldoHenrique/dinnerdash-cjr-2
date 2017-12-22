class MealsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin

  def create
    @meal_category = MealCategory.find(params[:meal_category_id])
    @meal = @meal_category.meals.create(meal_params)

    if params[:image].present?
      @image_id = params[:image].to_s.match(/(?<==>")(.+)(?="})/).to_s
      preloaded = Cloudinary::PreloadedFile.new(@image_id)
      raise "Invalid upload signature" if !preloaded.valid?
      @meal.image = preloaded.identifier
      @meal.save
    end

    redirect_to meal_category_path(@meal_category)
  end

  private
    def meal_params
      params.require(:meal).permit(:name, :description, :price, :image, :available)
    end
end
