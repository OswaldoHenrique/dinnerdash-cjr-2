Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :meal_categories do
    resources :meals
  end

  root 'home#index'
end
