Alotto::Application.routes.draw do
  resources :jackpots

  resources :games

  resources :users
  resources :sessions,      only: [:new, :create, :destroy]
  resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  root to: 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/faq',    to: 'static_pages#faq',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/updates', to: 'games#test_game_check', via: 'get'
  match '/heliwin', to: 'games#helicopter_check', via: 'get'
  match '/memorywin', to: 'games#memory_check', via: 'get'
  match '/get_advertisers', to: 'games#get_advertisers', via: 'get'
  match '/reset_timer', to: 'games#reset_game', via: 'get'
  match '/get_advertiser_logo', to: 'games#get_advertiser_logo', via: 'get'
  match '/deposit',  to: 'jackpots#show',         via: 'get'

end
