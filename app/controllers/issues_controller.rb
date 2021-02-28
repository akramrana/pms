class IssuesController < ApplicationController
  
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
    @issues = Issue.paginate(page: params[:page]).order('id DESC')
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
    @issue.destroy
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
