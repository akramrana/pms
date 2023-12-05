class ApplicationController < ActionController::Base
  include SessionsHelper
  add_breadcrumb "Home", :root_path

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
