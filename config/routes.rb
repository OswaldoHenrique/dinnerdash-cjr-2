Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :meal_categories

  root 'home#index'
end
