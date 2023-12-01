class IssueChecklistsController < ApplicationController
  before_action :logged_in_user
  before_action :set_issue_checklist, only: [:show, :edit, :update, :destroy]

  # GET /issue_checklists
  # GET /issue_checklists.json
  def index
    @issue_checklists = IssueChecklist.all
  end

  # GET /issue_checklists/1
  # GET /issue_checklists/1.json
  def show
  end

  # GET /issue_checklists/new
  def new
    @issue_checklist = IssueChecklist.new
  end

  # GET /issue_checklists/1/edit
  def edit
  end

  # POST /issue_checklists
  # POST /issue_checklists.json
  def create
    @issue_checklist = IssueChecklist.new(issue_checklist_params)
    @issue_checklist.created_at = Time.now
    @issue_checklist.updated_at = Time.now
    @issue_checklist.user_id = session[:user_id];
    respond_to do |format|
      if @issue_checklist.save

        @issueActivities = IssueActivity.new
        @issueActivities.issue_id = @issue_checklist.issue_id
        @issueActivities.user_id = @issue_checklist.user_id
        @issueActivities.description = 'added a checklist item '+@issue_checklist.description
        @issueActivities.save

        AppMailer.checklist_issue_email(@issue_checklist, session).deliver

        format.html { redirect_to @issue_checklist, notice: 'Issue checklist was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /issue_checklists/1
  # PATCH/PUT /issue_checklists/1.json
  def update
    respond_to do |format|
      if @issue_checklist.update(issue_checklist_params)
        format.html { redirect_to @issue_checklist, notice: 'Issue checklist was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue_checklist }
      else
        format.html { render :edit }
        format.json { render json: @issue_checklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_checklists/1
  # DELETE /issue_checklists/1.json
  def destroy
    @issue_checklist.destroy
    respond_to do |format|
      format.html { redirect_to issue_checklists_url, notice: 'Issue checklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def quick_create
    @issueChecklist = IssueChecklist.new
    render :layout => false 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_checklist
      @issue_checklist = IssueChecklist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_checklist_params
      params.require(:issue_checklist).permit(:issue_id, :description)
    end
end
