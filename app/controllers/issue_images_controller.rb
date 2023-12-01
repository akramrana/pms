class IssueImagesController < ApplicationController
  before_action :logged_in_user
  before_action :set_issue_image, only: [:show, :edit, :update, :destroy]

  # GET /issue_images
  # GET /issue_images.json
  def index
    @issue_images = IssueImage.all
  end

  # GET /issue_images/1
  # GET /issue_images/1.json
  def show
  end

  # GET /issue_images/new
  def new
    @issue_image = IssueImage.new
  end

  # GET /issue_images/1/edit
  def edit
  end

  # POST /issue_images
  # POST /issue_images.json
  def create
    @issue_image = IssueImage.new(issue_image_params)
    @issue_image.userId = session[:user_id];
    respond_to do |format|
      if @issue_image.save
        
        @issueActivities = IssueActivity.new
        @issueActivities.issue_id = @issue_image.issueId
        @issueActivities.user_id = @issue_image.userId
        @issueActivities.description = 'added an attachment'
        @issueActivities.save

        AppMailer.attachment_issue_email(@issue_image, session).deliver

        format.html { redirect_to @issue_image, notice: 'Issue image was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /issue_images/1
  # PATCH/PUT /issue_images/1.json
  def update
    respond_to do |format|
      if @issue_image.update(issue_image_params)
        format.html { redirect_to @issue_image, notice: 'Issue image was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue_image }
      else
        format.html { render :edit }
        format.json { render json: @issue_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_images/1
  # DELETE /issue_images/1.json
  def destroy
    @issue_image.destroy
    respond_to do |format|
      format.html { redirect_to issue_images_url, notice: 'Issue image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def quick_create
    @issueImage = IssueImage.new
    render :layout => false 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_image
      @issue_image = IssueImage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_image_params
      params.require(:issue_image).permit(:issueId, :image)
    end
end
