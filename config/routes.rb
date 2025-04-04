Rails.application.routes.draw do
  resources :brands, only: [:index, :create] do
    get 'models', to: 'brands#models'
  
    resources :models, only: [:create]
  end

  resources :models, only: [:index,:update]

  get "up" => "rails/health#show", as: :rails_health_check
end