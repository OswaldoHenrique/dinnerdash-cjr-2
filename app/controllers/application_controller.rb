class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :clear_order, if: -> { !Order.where(id: session[:current_order_id]).any? }
  before_action :current_order, if: -> { session[:current_order_id].nil? }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end

  def clear_order
    session[:current_order_id] = nil
  end

  def current_order
    @order = Order.new
    @order.status = 0
    @order.price = 0
    @order.save
    session[:current_order_id] = @order.id
  end
end
