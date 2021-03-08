class SessionsController < ApplicationController
  
  def new
    render partial:"new"
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:username] = user.username
      session[:email] = user.email
      session[:usertype] = user.usertype
      session[:createUserId] = user.createUserId
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now[:alert] = "Email or password is invalid"
      render partial:"new"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:username] = nil
    session[:email] = nil
    session[:usertype] = nil
    session[:createUserId] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
