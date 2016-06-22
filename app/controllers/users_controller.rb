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
        @active_users = @users.where(enabled:[true,nil])

        respond_to do |format|
            format.html
            format.csv { send_data @active_users.to_csv }
            format.xls { send_data @active_users.to_csv(col_sep: "\t") }
        end
    end

    def show
        @current_page = "profile"
        all_games = Game.where.not(device_type:nil).order(:slug)

        # Set up json arr
        # if was still credits UserGameSession.where(user_id:current_user.id,game_id:game_id).sum(:credits_earned)
        # making not score 0 and nil gets rid of weird extra sessions
        @json_arr = []

        all_games.each do |game|
            @json_arr << {label: game.name, count: UserGameSession.where(user_id:current_user.id,game_id:game.id).where.not(score:nil,score:0).count }
        end

        @json_arr = @json_arr.to_json

        render "show_mobile" if is_mobile?
    end

    def stats
    end

    def validate_email
        email = params[:email]
        email = email.downcase

        if User.where(email: email).present?
            render json: email = {:available => false}
        else
            render json: email = {:available => true}
        end
    end

    def validate_name
        name = params[:name]
        name = name.downcase

        if  signed_in? && current_user && current_user.name != name && User.where('lower(name) = ?', name).present?
            render json: data = {:available => false, :name => name}
        elsif User.where('lower(name) = ?', name).present?
            render json: data = {:available => false, :name => name}
        else
            render json: data = {:available => true, :name => name}
        end
    end

    def update_username
        if current_user && params[:user] && params[:user][:name]
            current_user.name = params[:user][:name]
            current_user.save
        end
        redirect_to games_path
    end

    def new
        @waitlist_user = WaitlistUser.new
        @user = User.new
        @is_mobile = is_mobile?
    end

    def create
        @user = User.new(user_params)

        if !signups_allowed?
            flash[:notice] = 'We are currently restricting new users for our closed beta. Please join our wait list to receive an invite in the future!'
            redirect_to root_path
        else
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
                    arrival.save
                end
                if session[:referred_user_id]
                    referral_user = User.where(id:session[:referred_user_id]).first
                    if referral_user
                        referral_user.add_credits({credits:get_refer_credits(referral_user.user_type_name)})
                        referral_user.save
                        session[:referred_user_id] = nil
                    end
                end

                #some weird things, the request doesnt exist
                if request && request.user_agent
                    user_agent = request.user_agent
                else
                    user_agent = ""
                end
                session[:user] = @user
                UserNotifier.send_confirmation_email({user_id: @user.id,verify_token:@user.verify_token}).deliver
                redirect_to verify_path
            else
                flash[:error] = "We're sorry! Something went wrong. Please check your email and username again."
                redirect_to root_path
            end
        end
    end

    def verify
        @user = session[:user]
        render "verify_mobile" if is_mobile?
    end

    def confirmed
        if params[:vid] && User.find_by_verify_token(params[:vid])
            user = User.find_by_verify_token(params[:vid])
            sign_in user
            user.email_activate
            render "confirmed_mobile" if is_mobile?
        elsif signed_in? && current_user && !current_user.profile_complete?
            @verified_incomplete = true
            render "confirmed_mobile" if is_mobile?
        else
            redirect_to root_path
        end
    end

    def update_verify
        @user = session[:user]
        UserNotifier.send_confirmation_email({user_id: @user.id,verify_token:@user.verify_token}).deliver
    end

    def resend_verify
        @user = session[:user]
        UserNotifier.send_confirmation_email({user_id: @user.id,verify_token:@user.verify_token}).deliver

        respond_to do |format|
          format.html { redirect_to root_path }
          format.js
        end
    end

    def challenges
        if signed_in?
            @challenges = current_user.challenges
        end
    end

    def user_details
        if !params[:first_name].blank? && !params[:last_name].blank? && !params[:gender].blank? && !params[:birthday].blank?
            current_user.firstname = params[:first_name]
            current_user.lastname = params[:last_name]
            current_user.gender = params[:gender]
            current_user.dob = Date.strptime(params[:birthday], "%m/%d/%Y")

            if !params[:username].blank?
                current_user.name = params[:username]
            end

            if current_user.dob > 13.years.ago || current_user.dob < 125.years.ago
                flash[:error] = "You must enter a valid date of birth, and be at least 13 years of age to play."
                redirect_to confirmed_path
            elsif current_user.save
                redirect_to root_path
            else
                redirect_to confirmed_path
            end
        else
            flash[:error] = "All fields are required. Please fill out all fields to continue."
            redirect_to confirmed_path
        end
    end

    def correct_mail
        @message = "Error: Something went wrong. Please check the email you entered and try again."
        @status = "fail"
        if !session[:user].blank? && !params[:e].blank?
            @user = session[:user]
            @user.email = params[:e]
            if @user.save
                UserNotifier.send_confirmation_email({user_id: @user.id,verify_token:@user.verify_token}).deliver
                @message = "Success! Please check your email #{@user.email} to verify."
                @status = "Success"
            elsif User.where(email:params[:e].downcase).present?
                @message = "Error: An user with that email already exists. "
            end
        else
            @message = "You must enter an email"
        end


        respond_to do |format|
          format.html { redirect_to root_path }
          format.js
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
