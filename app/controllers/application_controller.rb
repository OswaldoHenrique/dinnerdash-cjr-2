class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_id, if: -> {
    !Order.where(id: session[:current_order_id]).any?
  }
  before_action :current_order, if: -> {
    session[:current_order_id].nil?
  }
  before_action :set_user, if: -> {
    user_signed_in? &&
      Order.find(session[:current_order_id]).user_id.nil?
  }
  before_action :user_out, if: -> {
    !user_signed_in? &&
      !Order.find(session[:current_order_id]).user_id.nil?
  }
  before_action :finalize_order, if: -> {
    Order.find(session[:current_order_id]).status != 0
  }
  after_action :current_order, if: -> {
    session[:current_order_id].nil?
  }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end

  def ensure_id
    session[:current_order_id] = nil
  end

  def current_order
    @order = Order.new
    @order.status = 0
    @order.price = 0
    @order.save
    session[:current_order_id] = @order.id
  end

  def set_user
    if user_signed_in?
      @order = Order.find(session[:current_order_id])
      @order.user_id = current_user.id
      @order.save
    end
  end

  def finalize_order
    session[:current_order_id] = nil
  end

  def user_out
    session[:current_order_id] = nil
  end
end
