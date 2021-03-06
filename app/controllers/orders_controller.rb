class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to @order
    else
      render 'new'
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.status = 1
    @order.save

    flash[:notice] = "Obrigado. Seu pedido foi recebido."

    redirect_to home_index_path
  end

  private
  def order_params
    params.require(:order).permit(:status, :price, :user_id)
  end
end
