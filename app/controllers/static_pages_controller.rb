class StaticPagesController < ApplicationController
  include ApplicationHelper

  layout :determine_layout
  before_filter :check_signed_in, :only => [:redeem,:redeem_credits,:refer,:new_cash_out,:new_donation]

  def check_signed_in
    redirect_to root_path if !signed_in?
  end

  def home
    user_agent = request.user_agent

    if user_agent.include?("FBIOS" && "iPhone")
        binding.pry
    elsif user_agent.include?("Twitter for iPhone")
        binding.pry
    end

     if !signed_in?
      @current_jackpot = Jackpot.where(open: true).first
      @user = User.new
       if is_mobile?
        render "static_pages/home_mobile"
       end
     else
      redirect_to games_path
     end
  end

  def set_username
    if current_user
      @user = current_user
    else
      redirect_to root_path
    end
  end

  def home_invite
    referred_user_id = User.where(referral:params[:referral]).first
    if referred_user_id
      session[:referred_user_id] = referred_user_id.id
    end
    redirect_to root_path
  end

  def onboarding
  end

  def refer
    @show_back_button = true
    @referal_code = nil
    if signed_in?
      @referal_code = current_user.referral
    end

    if is_mobile?
      render "static_pages/refer_mobile"
    end
  end

  def faq
  end

  def about
  end

  def contact
  end

  def redeem
    @current_page = "redeem"
    @show_back_button = true

    if is_mobile?
      render "static_pages/redeem_mobile"
    end
  end

  def donate
    @show_back_button = true

    if is_mobile?
      render "static_pages/donate_mobile"
    end
  end

  def new_donation
    @show_back_button = true
    @cash_out = CashOut.new(cash_out_params)
    if session[:arrival_id]
      @cash_out.arrival_id = session[:arrival_id]
    end
    case @cash_out.credits
      when 1000
        @cash_out.cash = 5
      when 1950
        @cash_out.cash = 10
      when 3900
        @cash_out.cash = 20
    end

    if current_user.credits < @cash_out.credits
      redirect_to donate_credits_path(credits:@cash_out.credits), alert: "You dont have enough credits to cash that out! This requires #{@cash_out.credits}, and you have #{current_user.credits}."
    elsif !@cash_out.cashout_type.nil? && @cash_out.save
        @current_user.credits = current_user.credits - @cash_out.credits
        current_user.pending_credits = @cash_out.credits
        current_user.save
        if Rails.env.production?
          UserNotifier.send_donation_email({user_id:current_user.id}).deliver
        end

    else
      redirect_to donate_credits_path(credits:@cash_out.credits), alert: "Something went wrong. Please check the fields and try again."
    end
  end



  def new_cash_out
    @show_back_button = true
    @cash_out = CashOut.new(cash_out_params)
    if session[:arrival_id]
      @cash_out.arrival_id = session[:arrival_id]
    end
    case @cash_out.credits
      when 1000
        @cash_out.cash = 5
      when 1950
        @cash_out.cash = 10
      when 3900
        @cash_out.cash = 20
    end

    if @cash_out.cashout_type == 1 && !params[:first_name].blank? && !params[:last_name].blank? && !params[:email].blank?
      u = current_user
      u.firstname = params[:first_name]
      u.lastname = params[:last_name]
      u.save
      @cash_out.paypal = params[:email]
    end

    if current_user.credits < @cash_out.credits
      redirect_to redeem_credits_path(credits:@cash_out.credits), alert: "You dont have enough credits to cash that out! This requires #{@cash_out.credits}, and you have #{current_user.credits}."
    elsif !@cash_out.cashout_type.nil? && (!@cash_out.paypal.blank? || !@cash_out.venmo.blank?) && @cash_out.save
        @current_user.credits = current_user.credits - @cash_out.credits
        current_user.pending_credits = @cash_out.credits
        current_user.save
        if Rails.env.production?
          UserNotifier.send_cash_out_email({user_id:current_user.id}).deliver
        end

    else
      redirect_to redeem_credits_path(credits:@cash_out.credits), alert: "Something went wrong. Please check the fields and try again."
    end
  end

  def redeem_credits
    @back_button_action = "back-choice"
    @show_back_button = true
    @amount = params[:credits]
    @cash_out = CashOut.new

    if is_mobile?
      render "static_pages/redeem_credits_mobile"
    end
  end

  def donate_credits
    @back_button_action = "back-choice"
    @show_back_button = true
    @amount = params[:credits]

    if @amount == "1000"
      @dollar_amt = 5
    elsif @amount == "1950"
      @dollar_amt = 10
    elsif @amount == "3900"
      @dollar_amt = 20
    end

    @cash_out = CashOut.new

    if is_mobile?
      render "static_pages/donate_credits_mobile"
    end
  end

  # Tutorials
  def twentyfortyeight_tut
    @show_back_button = true
    @game = Game.where(name: "2048").first
  end

  private
    def cash_out_params
      params.require(:cash_out).permit(:user_id, :credits, :cash,:venmo,:paypal,:cashout_type)
    end
end
