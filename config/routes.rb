Rails.application.routes.draw do
  mount Attachinary::Engine => "/attachinary"
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  get '/spots/pendings', to: 'spots/pendings#index'

  resources :users, only: [ :show, :edit, :update ]
  resources :favorite_spots, only: [ :create, :index, :destroy ]
  resources :spots do
    resources :reviews, only: [ :new, :create ]
    resources :weather_feedbacks, only: [ :new, :create ]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
