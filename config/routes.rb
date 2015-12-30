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
  resources :cash_outs, only: [:create]
  root to: 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/faq',    to: 'static_pages#faq',    via: 'get'
  match '/how_it_works', to: 'static_pages#how_it_works', via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/redeem',   to: 'static_pages#redeem',   via: 'get'
  match '/donate',   to: 'static_pages#donate',   via: 'get'
  match '/redeem_credits/(:credits)',   to: 'static_pages#redeem_credits',as: 'redeem_credits',  via: 'get'
  match '/donate_credits/(:credits)',   to: 'static_pages#donate_credits',as: 'donate_credits',  via: 'get'
  match '/refer',   to: 'static_pages#refer',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/2048_tutorial', to: 'static_pages#twentyfortyeight_tut', via: 'get'
  match '/updates', to: 'games#test_game_check', via: 'get'
  match '/user_survey', to: 'surveys#user_survey_save', via: 'patch'
  match '/heliwin', to: 'games#helicopter_check', via: 'get'
  match '/sorcend', to: 'games#sorcerer_end', via: 'get'
  match '/score_update', to: 'games#score_update', via: 'get'
  match '/score_update', to: 'games#score_update', via: 'post'
  match '/close_game', to: 'games#close_game', via: 'post' 
  match '/close_game', to: 'games#close_game', via: 'get'    
  match '/new_game', to: 'games#new_game_session', via: 'get'
  match '/reset_game', to: 'games#reset_game', via: 'get'
  match '/reset_game', to: 'games#reset_game', via: 'post'
  match '/memorywin', to: 'games#memory_check', via: 'get'
  match '/challenge/:game_slug', to: 'games#challenge', as: 'game_challenge', via: 'get' 
  match '/challenge_play/:c', to: 'games#show', as: 'challenge_accept', via: 'get'  
  match '/challenge_user', to: 'games#challenge_create',as: 'challenges', via: 'post'  
  match '/ro', to: 'games#get_random_challenge_user', via: 'get'
  match '/leaderboard/:game_slug', to: 'games#leaderboard', as: 'game_leaderboard', via: 'get'
  match '/leaderboard', to: 'games#games_leaderboard', via: 'get'
  match '/cash_out', to: 'static_pages#new_cash_out', via: 'post'
  match '/donation', to: 'static_pages#new_donation', via: 'post'
  match '/get_advertisers', to: 'games#get_advertisers', via: 'get'
  match '/reset_timer', to: 'games#reset_game', via: 'get'
  match '/get_advertiser_logo', to: 'games#get_advertiser_logo', via: 'get'
  match '/current_jackpot', to:'jackpots#current_jackpot', via: 'get'
  match '/deposit',  to: 'jackpots#show',         via: 'get'
  match '/stats', to: 'users#stats', via: 'get'
  match '/challenges', to: 'users#challenges',as: 'user_challenges', via: 'get'  
  match '/invite/:referral',  to: 'static_pages#home_invite',         via: 'get'
  get 'auth/:provider/callback', to: 'sessions#create_from_facebook'

end
