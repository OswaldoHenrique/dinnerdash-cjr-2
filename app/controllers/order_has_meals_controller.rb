class OrderHasMealsController < ApplicationController
  after_action :set_order_price, only: [:create, :update]

  def create
    @order = Order.find(session[:current_order_id])
    @meal = Meal.find(params[:order_has_meal][:meal_id])

    attrs = order_has_meal_params.clone
    attrs[:price] = (@meal.price*attrs[:quantity].to_f)

    @order_has_meal = @order.order_has_meals.create(attrs)
    redirect_to order_path(@order)
  end

  def update
    @order = Order.find(session[:current_order_id])
    @meal = Meal.find(params[:order_has_meal][:meal_id])
    @order_has_meal = @order.order_has_meals.find_by(meal_id: @meal.id)

    attrs = order_has_meal_params.clone
    attrs[:price] = (@meal.price*attrs[:quantity].to_f)

    if @order_has_meal.update(attrs)
      redirect_to Order.find(session[:current_order_id])
    else
      render 'order_has_meals/form'
    end
  end

  private
    def order_has_meal_params
      params.require(:order_has_meal).permit(:quantity, :price, :meal_id)
    end

    def set_order_price
      @order = Order.find(session[:current_order_id])
      @order.price = 0

      @order.order_has_meals.each do |m|
        @order.price += m.price
      end

      @order.save
    end
end
