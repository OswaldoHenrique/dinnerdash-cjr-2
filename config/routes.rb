Rails.application.routes.draw do
  get 'backoffice/index'

  get 'home/index'

  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :orders do
    resources :order_has_meals
  end

  resources :meal_categories do
    resources :meals
  end

  root 'home#index'
end
