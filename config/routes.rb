Alotto::Application.routes.draw do
  resources :surveys

  resources :feed_games

  resources :jackpots

  resources :games

  resources :users
  resources :sessions,      only: [:new, :create, :destroy]
  resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  root to: 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/faq',    to: 'static_pages#faq',    via: 'get'
  match '/how_it_works', to: 'static_pages#how_it_works', via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/redeem',   to: 'static_pages#redeem',   via: 'get'
  match '/refer',   to: 'static_pages#refer',   via: 'get'  
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/updates', to: 'games#test_game_check', via: 'get'
  match '/user_survey', to: 'surveys#user_survey_save', via: 'patch'
  match '/heliwin', to: 'games#helicopter_check', via: 'get'
  match '/sorcend', to: 'games#sorcerer_end', via: 'get'
  match '/score_update', to: 'games#score_update', via: 'get'
  match '/score_update', to: 'games#score_update', via: 'post'
  match '/new_game', to: 'games#new_game_session', via: 'get'
  match '/reset_game', to: 'games#reset_game', via: 'get'
  match '/reset_game', to: 'games#reset_game', via: 'post'  
  match '/memorywin', to: 'games#memory_check', via: 'get'
  match '/get_advertisers', to: 'games#get_advertisers', via: 'get'
  match '/reset_timer', to: 'games#reset_game', via: 'get'
  match '/get_advertiser_logo', to: 'games#get_advertiser_logo', via: 'get'
  match '/current_jackpot', to:'jackpots#current_jackpot', via: 'get'
  match '/deposit',  to: 'jackpots#show',         via: 'get'
  match '/invite/:referral',  to: 'static_pages#home_invite',         via: 'get'  
  get 'auth/:provider/callback', to: 'sessions#create_from_facebook'
  
end
