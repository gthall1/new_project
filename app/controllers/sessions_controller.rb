class SessionsController < ApplicationController
    include ApplicationHelper
    
    layout :determine_layout

    def new
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
        if env['omniauth.auth'].info.email
            user = User.omniauth(env['omniauth.auth'],session[:arrival_id])
        end
        if user
            if !user.oath_token.blank?
                session[:auth_token] = user.oath_token
            end
            sign_in user
            cookies.permanent[:u] = user.id
            if session[:arrival_id]
                a = Arrival.where(id:session[:arrival_id]).first
                if a
                    a.user_id = user.id
                    a.save
                end
            end  
            if user.created_at > Time.now-5.minutes
                redirect_to set_username_path
            else    
                redirect_to root_path
            end
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

    def destroy
        sign_out
        redirect_to root_url
    end
end
