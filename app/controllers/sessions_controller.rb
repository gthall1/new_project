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
    user = User.omniauth(env['omniauth.auth'])
    if user
      sign_in user
      redirect_to root_url
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
