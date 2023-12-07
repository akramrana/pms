class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :load_notification
  add_breadcrumb "Home", :root_path

  def load_notification
    @unread = 0;
    if session[:usertype] == 1
      @unread = Notification.where("isRead = 0 AND userId is null").count
    elsif 
      @unread = Notification.where(:isRead => 0, :userId => session[:user_id] ).count
    end
  end

  private
    def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
    end

    def admin_only
      if session[:usertype]!=1
        flash[:danger] = "Access Denied."
        redirect_to root_path
      end
    end

  
end
