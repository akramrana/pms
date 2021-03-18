class IssuesController < ApplicationController
  before_action :logged_in_user
  add_breadcrumb "Issue", :issues_path

  before_action :set_issue, only: [:show, :edit, :update, :destroy, :board_list, :quick_create]
  before_action :prepare_user_list
  before_action :prepare_priority_type
  before_action :prepare_issue_type
  before_action :prepare_project_list

  # GET /issues
  # GET /issues.json
  def index
    add_breadcrumb "List", issues_path
    @issues = Issue.paginate(page: params[:page]).where(:is_deleted => 0).order('id DESC')
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    add_breadcrumb @issue.id
  end

  # GET /issues/new
  def new
    add_breadcrumb "New"
    @issue = Issue.new
    @boards = []
    @issueBoardId = '';
  end

  # GET /issues/1/edit
  def edit
    add_breadcrumb @issue.id, issue_path
    add_breadcrumb "Update"
    @boards = Board.where(:projectId => @issue.projectId)
    @boardissue = BoardIssue.where(:issueId => @issue.id).first
    @issueBoardId = @boardissue.boardId;
    #Rails.logger.debug @boardissue.inspect
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.addedTime = Time.now
    @boards = []
    @issueBoardId = '';

    respond_to do |format|
      if @issue.save
        # Rails.logger.debug params[:issue][:boardId].inspect
        @boardIssue = BoardIssue.new()
        @boardIssue.boardId = params[:issue][:boardId]
        @boardIssue.issueId = @issue.id
        @boardIssue.save

        
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    @boards = Board.where(:projectId => @issue.projectId)
    respond_to do |format|
      if @issue.update(issue_params)
        BoardIssue.where(issueId: @issue.id).destroy_all
        @boardIssue = BoardIssue.new()
        @boardIssue.boardId = params[:issue][:boardId]
        @boardIssue.issueId = @issue.id
        @boardIssue.save

        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    #@issue.destroy
    @issue.attributes = {is_deleted:1}
    @issue.save(validate: false)

    BoardIssue.where(:issueId => @issue.id).destroy_all

    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def board_list
    respond_to do |format|
      @boards = Board.where(:projectId => params[:id])
      format.json{ render :json => @boards }
    end
  end

  def quick_create
    @issue = Issue.new
    @boards = []
    @issueBoardId = '';

    render :layout => false 
  end
  
  def move
    @issue = Issue.find(params[:id])
    @boardId = params[:boardId];
    BoardIssue.delete_by(issueId:@issue.id)

    @boardIssue = BoardIssue.new
    @boardIssue.boardId = @boardId;
    @boardIssue.issueId = @issue.id;
    @boardIssue.save

    respond_to do |format|
      format.json {render json: @boardIssue, status: :ok}
    end

  end

  def add_comment
    @issue = Issue.find(params[:id])

    @issueComment = IssueComment.new()
    @issueComment.issueId = @issue.id
    @issueComment.userId = 1
    @issueComment.comment = params[:comment]
    @issueComment.time = Time.now
    @issueComment.save

    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueComment.issueId
    @issueActivities.user_id = @issueComment.userId
    @issueActivities.description = 'added a comment '+@issueComment.comment
    @issueActivities.save


    respond_to do |format|
      format.json {render json: @issueComment, status: :ok}
    end
  end

  def complete_checklist
    @issue = Issue.find(params[:id])
    @issueChecklist = IssueChecklist.find(params[:issue_checklist_id])
    @completed = params[:is_checked]

    if @completed=='1'
      @issueChecklist.completed_by = 1;
      @issueChecklist.is_completed = 1
      @issueChecklist.save

      @issueActivities = IssueActivity.new
      @issueActivities.issue_id = @issue.id
      @issueActivities.user_id = 1
      @issueActivities.description = 'completed a checklist item'
      @issueActivities.save
    else
      @issueChecklist.completed_by = nil;
      @issueChecklist.is_completed = 0
      @issueChecklist.save

      @issueActivities = IssueActivity.new
      @issueActivities.issue_id = @issue.id
      @issueActivities.user_id = 1
      @issueActivities.description = 're-open a checklist item'
      @issueActivities.save
    end

    respond_to do |format|
      format.json {render json: @issueChecklist, status: :ok}
    end

  end

  def change_status
    @issue = Issue.find(params[:id])
    @type = params[:type]
    @comment = '';
    if @type == 'start'
      @issue.attributes = {start:1, stop:0, reopen:0}
      @comment = 'started'
    end
    if @type == 'stop'
      @issue.attributes = {start:0, stop:1}
      @comment = 'stopped'
    end
    if @type == 'done'
      @issue.attributes = {start:0, stop:0, done:1}
      @comment = 'completed'
    end
    if @type == 'reopen'
      @issue.attributes = {reopen:1, done:0}
      @comment = 'reopened'
    end 
    @issue.save(validate: false)

    @issueHistory = IssueHistory.new
    @issueHistory.history_type = @type
    @issueHistory.issue_id = @issue.id
    @issueHistory.user_id = 1
    @issueHistory.created_at = Time.now
    @issueHistory.save

    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueHistory.issue_id
    @issueActivities.user_id = @issueHistory.user_id
    @issueActivities.description = @comment+' the issue'
    @issueActivities.save

    respond_to do |format|
      format.json {render json: @issue, status: :ok}
    end
  end

  def delete_comment
    @issue = Issue.find(params[:id])
    @commentId = params[:commentId]
    
    @issueComment = IssueComment.find(@commentId)
    @issueComment.attributes = {is_deleted:1}
    @issueComment.save(validate: false)

    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueComment.issueId
    @issueActivities.user_id = @issueComment.userId
    @issueActivities.description = 'deleted a comment'
    @issueActivities.save

    respond_to do |format|
      format.json {render json: @issue, status: :ok}
    end
  end
  
  def delete_checklist_item
    @issue = Issue.find(params[:id])
    @issueCecklistId = params[:issueCecklistId]
    
    @issueChecklist = IssueChecklist.find(@issueCecklistId)
    @issueChecklist.attributes = {is_deleted:1}
    @issueChecklist.save(validate: false)

    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueChecklist.issue_id
    @issueActivities.user_id = @issueChecklist.user_id
    @issueActivities.description = 'deleted a checklist item'
    @issueActivities.save

    respond_to do |format|
      format.json {render json: @issue, status: :ok}
    end
  end

  def delete_attachment
    @issue = Issue.find(params[:id])
    @imageId = params[:imageId]
    
    @issueImage = IssueImage.find(@imageId)
    
    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueImage.issueId
    @issueActivities.user_id = @issueImage.userId
    @issueActivities.description = 'deleted an attachment'
    @issueActivities.save

    @issueImage.destroy

    respond_to do |format|
      format.json {render json: @issue, status: :ok}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:projectId, :issueTypeId, :summary, :priorityTypeId, :dueDate, :assignee, :reporter, :environment, :description, :originalEstimate, :remainEstimate, :boardId)
    end

    def prepare_priority_type
      @priorityTypes = PriorityType.all
    end

    def prepare_user_list
      @users = User.where(usertype: '2').all
    end
    
    def prepare_issue_type
      @issueTypes = IssueType.all
    end
    
    def prepare_project_list
      @projects = Project.all
    end


end
