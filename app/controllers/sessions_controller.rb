class SessionsController < ApplicationController
    include ApplicationHelper

    layout :determine_layout

    def new
        @waitlist_user = WaitlistUser.new
        render "sessions/new_mobile" if is_mobile?
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            sign_in user
            cookies.permanent[:u] = user.id
            if session[:arrival_id]
                a = Arrival.where(id:session[:arrival_id]).first
                if a
                    a.user_id = user.id
                    a.save
                end
            end
            redirect_to root_url
        else
            flash.now[:error] = 'Invalid email/password combination'
            if is_mobile?
                render "sessions/new_mobile"
            else
                render 'new'
            end
        end
    end

    def create_from_facebook
        #this is when they connect later
        if signed_in? && current_user
            current_user.omniauth_connect(env['omniauth.auth'])
            redirect_to leaderboards_path
        else
            if env['omniauth.auth'].info.email && (signups_allowed? || User.where(email:env['omniauth.auth'].info.email).present?)
                user = User.omniauth(env['omniauth.auth'],session[:arrival_id])
            end
            if user
                if !user.oath_token.blank?
                    session[:auth_token] = user.oath_token
                end
                sign_in user unless !user.email_verified
                cookies.permanent[:u] = user.id
                if session[:arrival_id]
                    a = Arrival.where(id:session[:arrival_id]).first
                    if a
                        a.user_id = user.id
                        a.save
                    end
                end

                if user.created_at > Time.now-30.seconds
                    session[:user] = user
                    redirect_to verify_path
                elsif !user.email_verified && !user.profile_complete?
                    sign_in user
                    redirect_to confirmed_path
                elsif user.profile_complete?
                    sign_in user
                    redirect_to root_path 
                else        
                    redirect_to root_path           
                end

            elsif !signups_allowed?
                flash[:notice] = 'We are currently restricting new users for our closed beta. Please join our wait list to receive an invite in the future!'
                redirect_to root_path
            elsif env['omniauth.auth'].info.email.nil?
                flash.now[:error] = 'Email is required in order to contact you for cash outs.'
                @facebook_link = "/auth/facebook?auth_type=rerequest&scope=email"
                @user = User.new
                if is_mobile_device?
                    render '/static_pages/home_mobile'
                else
                    render '/static_pages/home'
                end
            else
                flash.now[:error] = 'Invalid email/password combination'
                render 'new'
            end
        end
    end

    def destroy
        sign_out
        redirect_to root_url
    end
end
