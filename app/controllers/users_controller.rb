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

        if User.where('lower(name) = ?', name).present? && current_user.name != name
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

                #only sending confirmation email as a way around native browses from twitter and facebook
                if user_agent.include?("iPhone" || "iPad" || "iPod") && user_agent.include?("FBAN")
                    UserNotifier.send_confirmation_email({user_id: @user.id,verify_token:@user.verify_token}).deliver
                    redirect_to confirm_email_path
                elsif user_agent.include?("iPhone" || "iPad" || "iPod") && user_agent.include?("Twitter for iPhone")
                    UserNotifier.send_confirmation_email({user_id: @user.id,verify_token:@user.verify_token}).deliver
                    redirect_to confirm_email_path
                else
                    sign_in @user
                    cookies.permanent[:u] = @user.id
                    flash[:success] = "Welcome to Luckee!"
                    redirect_to(root_url)
                end
            else
                render 'new'
            end
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
