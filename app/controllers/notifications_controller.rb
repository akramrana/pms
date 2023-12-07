class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :destroy, :mark_read]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.paginate(page: params[:page])
                    .left_joins(:project,:issue,:user)
                    .where(:isDeleted => 0)
                    .order('notifications.id DESC')

    @notifications = @notifications.where(:userId => session[:user_id]) if session[:usertype]!=1

    @notifications = @notifications.where("(projects.projectName LIKE :search OR issues.summary LIKE :search OR users.username LIKE :search)",search: "%#{params[:search]}%") if params[:search]
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    #@notification.destroy
    if session[:usertype] != 1
      if session[:user_id] != @notification.userId
        flash[:danger] = "Access Denied."
        redirect_to notifications_url
      end
    end
    @notification.attributes = {isDeleted:1}
    @notification.save(validate: false)
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mark_read
    @notification.attributes = {isRead:1}
    @notification.save(validate: false)
    respond_to do |format|
      format.html { redirect_to notifications_url}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:userId, :projectId, :description, :isRead, :createdAt, :updatedAt, :isDeleted)
    end
end
