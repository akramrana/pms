class SessionsController < ApplicationController
  
  def new
    render partial:"new"
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      user.attributes = {lastLoginTime:Time.now}
      user.save(validate: false)

      session[:user_id] = user.id
      session[:username] = user.username
      session[:email] = user.email
      session[:usertype] = user.usertype
      session[:createUserId] = user.createUserId
      session[:lastLoginTime] = user.lastLoginTime.strftime("%Y-%m-%d %I:%M %P")
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
