class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.paginate(page: params[:page])
                    .where(:isDeleted => 0)
                    .order('id DESC')
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
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
