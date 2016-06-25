Alotto::Application.routes.draw do


    root to: 'static_pages#home'

    resources :purchases
    resources :surveys
    resources :games
    resources :users
    resources :users do
        member do
          get :verify_email
        end
    end

    resources :sessions,      only: [:new, :create, :destroy]
    resources :password_resets,     only: [:new, :create, :edit, :update]
    resources :cash_outs, only: [:create]

    match '/signup',  to: 'users#new',            via: 'get'
    match '/signin',  to: 'sessions#new',         via: 'get'
    match '/signout', to: 'sessions#destroy',     via: 'delete'
    match '/user_survey', to: 'surveys#user_survey_save', via: 'patch'
    match '/current_jackpot', to:'jackpots#current_jackpot', via: 'get'
    match '/deposit',  to: 'jackpots#show',         via: 'get'
    match '/stats', to: 'users#stats', via: 'get'
    match '/challenges', to: 'users#challenges',as: 'user_challenges', via: 'get'
    match '/update_username',  to: 'users#update_username',         via: 'patch'
    match '/user_details',  to: 'users#user_details',         via: 'post'

    match '/verify', to: 'users#verify', via: 'get'
    match '/confirmed', to: 'users#confirmed', via: 'get'
    match '/correct_mail', to: 'users#correct_mail', via: 'post'
    # Static Pages
    # match '/kd', to: 'static_pages#kd_home', via: 'get'
    match '/faq',    to: 'static_pages#faq',    via: 'get'
    match '/onboarding', to: 'static_pages#onboarding', via: 'get'
    match '/how_it_works', to: 'static_pages#how_it_works', via: 'get'
    match '/about',   to: 'static_pages#about',   via: 'get'
    match '/confirm_email',   to: 'static_pages#confirm_email',   via: 'get'
    match '/redeem',   to: 'static_pages#redeem',   via: 'get'
    match '/donate',   to: 'static_pages#donate',   via: 'get'
    match '/redeem_credits/(:credits)',   to: 'static_pages#redeem_credits',as: 'redeem_credits',  via: 'get'
    match '/donate_credits/(:credits)',   to: 'static_pages#donate_credits',as: 'donate_credits',  via: 'get'
    match '/refer',   to: 'static_pages#refer',   via: 'get'
    match '/contact', to: 'static_pages#contact', via: 'get'
    match '/join_bellhops', to: 'static_pages#bellhops_affiliate', as:  "bellhops_affiliate", via: 'get'
    match '/2048_tutorial', to: 'static_pages#twentyfortyeight_tut', via: 'get'
    match '/cash_out', to: 'static_pages#new_cash_out', via: 'post'
    match '/donation', to: 'static_pages#new_donation', via: 'post'
    match '/invite/:referral',  to: 'static_pages#home_invite',         via: 'get'
    match '/set_username',  to: 'static_pages#set_username',         via: 'get'

    # Games Pages
    match '2048_home', to: 'games#twentyfortyeight_home', via: 'get'
    match '/updates', to: 'games#test_game_check', via: 'get'
    match '/heliwin', to: 'games#helicopter_check', via: 'get'
    match '/sorcend', to: 'games#sorcerer_end', via: 'get'
    match '/score_update', to: 'games#score_update', via: 'get'
    match '/score_update', to: 'games#score_update', via: 'post'
    match '/get_high_scores', to: 'games#get_high_scores', via: 'get'
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
    #match '/leaderboard/:game_slug', to: 'games#leaderboard', as: 'game_leaderboard', via: 'get'
    match '/leaderboard/:game_slug', to: 'games#leaderboard', as: 'game_leaderboard', via: 'get'
    match '/leaderboards', to: 'games#games_leaderboard', via: 'get'
    match '/get_advertisers', to: 'games#get_advertisers', via: 'get'
    match '/reset_timer', to: 'games#reset_game', via: 'get'
    match '/get_advertiser_logo', to: 'games#get_advertiser_logo', via: 'get'
    match '/games', to: 'games#get_games', via: 'get'
    match '/unlock_game/:slug', to: 'games#purchase_confirm', as: 'unlock_game', via: 'get'

    match '/us_only', to: 'static_pages#country', as: 'country', via: 'get'
    match '/closed_beta', to: 'static_pages#closed_beta', as: 'closed_beta', via: 'get'

    match '/waitlist_user', to: 'static_pages#waitlist_user', via: 'post'

    get 'auth/:provider/callback', to: 'sessions#create_from_facebook'

    # JSON Routes
    match '/validate_email', to: 'users#validate_email', via: 'get'
    match '/validate_name', to: 'users#validate_name', via: 'get'
    match '/correct_email', to: 'users#correct_mail', via: 'get'
    match '/resend_verify', to: 'users#resend_verify', via: 'post'
    #reps
    #same as referral but we giving this to them for ease and use of custom urls and tracking
    get '/r-:referral',to: 'static_pages#home_invite', via: 'get'

    match '/check_branded', to: 'games#check_branded', via: 'post'

    #For analytics to grab some data
    namespace :api, defaults: { format: :json } do
        namespace :v1 do
            scope ':token' do
                match '/users', to: 'users#get_users', via: 'get'
                match '/user_games', to: 'users#get_game_sessions', via: 'get'
                match '/arrivals', to: 'arrivals#get_arrivals', via: 'get'
                match '/games', to: 'games#get_games', via: 'get'
                match '/surveys', to: 'surveys#get_surveys', via: 'get'
                match '/user_surveys', to: 'surveys#get_user_surveys', via: 'get'
                match '/cashouts', to: 'users#get_cash_outs', via: 'get'
            end
        end
    end

    #CATCH ALL FOR PROMOS
    match '/:promo', to: 'static_pages#home', via: 'get'


end
