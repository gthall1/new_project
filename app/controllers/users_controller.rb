class UsersController < ApplicationController
  include ApplicationHelper

  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index, :destroy]

  layout :determine_layout

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end
