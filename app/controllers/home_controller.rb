class HomeController < ApplicationController
  def index
    @meal_categories = MealCategory.all
    @order = Order.find(session[:current_order_id])
  end
end
