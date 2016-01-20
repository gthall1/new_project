class UsersController < ApplicationController
  include ApplicationHelper

  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :show, :update]
  before_action :admin_user,     only: [:index,:stats, :destroy]

  layout :determine_layout

  def index
    @users = User.all
    @credits = User.total_user_credits

    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv }
      format.xls { send_data @users.to_csv(col_sep: "\t") }
    end
  end

  def show
    # @user = User.find(params[:id])
    @user = current_user
    @games = {}

    all_games = Game.all.order(:slug)

    all_games.each do |g|
      @games[g.slug] = 0
    end

    # Temp
    sql = "SELECT game_id, credits_earned FROM user_game_sessions WHERE user_game_sessions.user_id = #{@user.id}"
    connection = ActiveRecord::Base.connection
    result = connection.exec_query(sql)

    result.each do |r|
        game_slug = Game.find(r["game_id"]).slug
        @games[game_slug] += 1
    end
    # Temp End


    # Set up json arr
    @json_arr = []
    @games.each do |key, val|
      @json_arr << {label: key, count: val }
    end

    @json_arr = @json_arr.to_json
  end

  def stats
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if session[:arrival_id]
      @user.arrival_id = session[:arrival_id]
    elsif cookies[:a_id]
      @user.arrival_id = cookies[:a_id]
    end

    if @user.save
      if !@user.oath_token.blank?
        session[:auth_token] = @user.oath_token
      end
      arrival = Arrival.where(id:session[:arrival_id]).first
      if arrival
        arrival.user_id = @user.id
      end
      if session[:referred_user_id]
        referral_user = User.where(id:session[:referred_user_id]).first
        if referral_user
          referral_user.add_credits({credits:50})
          referral_user.save
          session[:referred_user_id] = nil
        end
      end
      sign_in @user
      cookies.permanent[:u] = @user.id
      flash[:success] = "Welcome to Luckee!"
      redirect_to(root_url)
    else
      render 'new'
    end
  end

  def challenges
    if signed_in?
      @challenges = current_user.challenges
    end
  end

  def edit
    @show_back_button = true
    render "users/edit_mobile" if is_mobile?
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,:gender,:dob,:zipcode,
                                   :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end

    def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
    end
  end
