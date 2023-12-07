class IssuesController < ApplicationController
  before_action :logged_in_user
  add_breadcrumb "Issue", :issues_path

  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :prepare_user_list
  before_action :prepare_priority_type
  before_action :prepare_issue_type
  before_action :prepare_project_list

  before_action :check_permission, only: [:destroy]

  # GET /issues
  # GET /issues.json
  def index
    add_breadcrumb "List", issues_path
    
    @projectsArr = [];
    if session[:usertype]== 2
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
    end

    if params[:search]
      wildcard_search = "%#{params[:search]}%"
      @issues = Issue.paginate(page: params[:page])
                      .joins(:project, :priorityType, :issueType, :assigneeUser, :reporterUser)
                      .where("issues.is_deleted = 0 AND (priority_types.priorityTypeName LIKE :search OR projects.projectName LIKE :search OR issue_types.issueTypeName LIKE :search OR users.username LIKE :search OR reporterUsers_issues.username LIKE :search)",search: wildcard_search)
                      .order('issues.id DESC')
      @issues = @issues.where(:projectId => @projectsArr) if session[:usertype]== 2

      @issues = @issues.where(:assignee => session[:user_id]) if session[:usertype]== 3 || session[:usertype]== 4
    else
      @issues = Issue.paginate(page: params[:page])
                    .where(:is_deleted => 0)
                    .order('id DESC')
      @issues = @issues.where(:projectId => @projectsArr) if session[:usertype]== 2

      @issues = @issues.where(:assignee => session[:user_id]) if session[:usertype]== 3 || session[:usertype]== 4
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    if session[:usertype]== 2
      @projectsArr = [];
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
      if not @projectsArr.include?(@issue.projectId)
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    elsif session[:usertype] == 3 || session[:usertype] == 4
      if session[:user_id] != @issue.assignee
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    end
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
    if session[:usertype]== 2
      @projectsArr = [];
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
      if not @projectsArr.include?(@issue.projectId)
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    elsif session[:usertype] == 3 || session[:usertype] == 4
      if session[:user_id] != @issue.assignee
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    end
    add_breadcrumb @issue.id, issue_path
    add_breadcrumb "Update"
    @boards = Board.where(:projectId => @issue.projectId)
                     .left_joins(:board_issues)
                     .joins("LEFT JOIN issues ON board_issues.issueId = issues.id")
                     .where("boards.is_deleted = 0")
                     .order('boards.id DESC')
                     .group('boards.id')
    @boards = @boards.where(issues:{:assignee => session[:user_id]}) if session[:usertype]== 3 || session[:usertype]== 4
    @boardissue = BoardIssue.where(:issueId => @issue.id).first
    if @boardissue
      @issueBoardId = @boardissue.boardId;
    end
    #Rails.logger.debug @boardissue.inspect
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.addedTime = Time.now
    @issue.reporter = session[:user_id]
    @boards = []
    @issueBoardId = '';

    respond_to do |format|
      if @issue.save
        # Rails.logger.debug params[:issue][:boardId].inspect
        @boardIssue = BoardIssue.new()
        @boardIssue.boardId = params[:issue][:boardId]
        @boardIssue.issueId = @issue.id
        @boardIssue.save

        AppMailer.add_issue_email(@issue).deliver

        @notification = Notification.new
        @notification.created_at = Time.now
        @notification.updated_at = Time.now
        @notification.userId = @issue.assignee
        @notification.projectId = @issue.projectId
        @notification.description = @issue.reporterUser.username+' assigned you an issue.'
        @notification.issueId = @issue.id
        @notification.save

        
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
    if session[:usertype]== 2
      @projectsArr = [];
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
      if not @projectsArr.include?(@issue.projectId)
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    elsif session[:usertype] == 3 || session[:usertype] == 4
      if session[:user_id] != @issue.assignee
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    end
    @boards = Board.where(:projectId => @issue.projectId)
    respond_to do |format|
      if @issue.update(issue_params)
        BoardIssue.where(issueId: @issue.id).destroy_all
        @boardIssue = BoardIssue.new()
        @boardIssue.boardId = params[:issue][:boardId]
        @boardIssue.issueId = @issue.id
        @boardIssue.save

        AppMailer.edit_issue_email(@issue, session).deliver

        @notification = Notification.new
        @notification.created_at = Time.now
        @notification.updated_at = Time.now
        @notification.userId = @issue.assignee
        @notification.projectId = @issue.projectId
        @notification.description = session[:username]+' updated an issue assigned to you.'
        @notification.issueId = @issue.id
        @notification.save

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
    if session[:usertype]== 2
      @projectsArr = [];
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
      if not @projectsArr.include?(@issue.projectId)
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    elsif session[:usertype] == 3 || session[:usertype] == 4
      if session[:user_id] != @issue.assignee
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    end
    @issue.attributes = {is_deleted:1}
    @issue.save(validate: false)

    BoardIssue.where(:issueId => @issue.id).destroy_all

    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def board_list
    @boards = Board.where(:projectId => params[:id], :is_deleted => 0)
                     .left_joins(:board_issues)
                     .joins("LEFT JOIN issues ON board_issues.issueId = issues.id")
                     .order('boards.id DESC')
                     .group('boards.id')
    @boards = @boards.where(issues:{:assignee => session[:user_id]}) if session[:usertype]== 3 || session[:usertype]== 4
    respond_to do |format|
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

    @notification = Notification.new
    @notification.created_at = Time.now
    @notification.updated_at = Time.now
    @notification.userId = @boardIssue.issue.assignee
    @notification.projectId = @boardIssue.issue.projectId
    @notification.description = session[:username]+' has moved the issue to '+@boardIssue.board.boardName
    @notification.issueId = @issue.id
    @notification.save

    respond_to do |format|
      format.json {render json: @boardIssue, status: :ok}
    end

  end

  def add_comment
    @issue = Issue.find(params[:id])

    @issueComment = IssueComment.new()
    @issueComment.issueId = @issue.id
    @issueComment.userId = session[:user_id]
    @issueComment.comment = params[:comment]
    @issueComment.time = Time.now
    @issueComment.save

    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueComment.issueId
    @issueActivities.user_id = @issueComment.userId
    @issueActivities.description = 'added a comment '+@issueComment.comment
    @issueActivities.save

    @notification = Notification.new
    @notification.created_at = Time.now
    @notification.updated_at = Time.now
    @notification.userId = @issueComment.issue.assignee
    @notification.projectId = @issueComment.issue.projectId
    @notification.description = @issueComment.user.username+' added a comment.'
    @notification.issueId = @issueComment.issueId
    @notification.save

    AppMailer.comment_issue_email(@issueComment, session).deliver

    respond_to do |format|
      format.json {render json: @issueComment, status: :ok}
    end
  end

  def complete_checklist
    @issue = Issue.find(params[:id])
    @issueChecklist = IssueChecklist.find(params[:issue_checklist_id])
    @completed = params[:is_checked]

    if @completed=='1'
      @issueChecklist.completed_by = session[:user_id];
      @issueChecklist.is_completed = 1
      @issueChecklist.save

      @issueActivities = IssueActivity.new
      @issueActivities.issue_id = @issue.id
      @issueActivities.user_id = session[:user_id]
      @issueActivities.description = 'completed a checklist item'
      @issueActivities.save

      @notification = Notification.new
      @notification.created_at = Time.now
      @notification.updated_at = Time.now
      @notification.userId = @issue.reporter
      @notification.projectId = @issue.projectId
      @notification.description = @issueActivities.user.username+' completed a checklist item.'
      @notification.issueId = @issue.id
      @notification.save

    else
      @issueChecklist.completed_by = nil;
      @issueChecklist.is_completed = 0
      @issueChecklist.save

      @issueActivities = IssueActivity.new
      @issueActivities.issue_id = @issue.id
      @issueActivities.user_id = session[:user_id]
      @issueActivities.description = 're-open a checklist item'
      @issueActivities.save

      @notification = Notification.new
      @notification.created_at = Time.now
      @notification.updated_at = Time.now
      @notification.userId = @issue.assignee
      @notification.projectId = @issue.projectId
      @notification.description = @issueActivities.user.username+' re-open a checklist item.'
      @notification.issueId = @issue.id
      @notification.save

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
    @issueHistory.user_id = session[:user_id]
    @issueHistory.created_at = Time.now
    @issueHistory.save

    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueHistory.issue_id
    @issueActivities.user_id = @issueHistory.user_id
    @issueActivities.description = @comment+' the issue'
    @issueActivities.save

    if @type == 'reopen'
      AppMailer.reopen_issue_email(@issueHistory, @issue, session).deliver

      @notification = Notification.new
      @notification.created_at = Time.now
      @notification.updated_at = Time.now
      @notification.userId = @issue.assignee
      @notification.projectId = @issue.projectId
      @notification.description = @issueActivities.user.username+' has '+@comment+' the issue assigned to you.'
      @notification.issueId = @issue.id
      @notification.save
    end
    if @type == 'done'
      AppMailer.done_issue_email(@issueHistory, @issue, session).deliver

      @notification = Notification.new
      @notification.created_at = Time.now
      @notification.updated_at = Time.now
      @notification.userId = @issue.reporter
      @notification.projectId = @issue.projectId
      @notification.description = @issueActivities.user.username+' has '+@comment+' the issue assigned by you.'
      @notification.issueId = @issue.id
      @notification.save
    end
    if @type == 'start' || @type == 'stop'
      @notification = Notification.new
      @notification.created_at = Time.now
      @notification.updated_at = Time.now
      @notification.userId = @issue.reporter
      @notification.projectId = @issue.projectId
      @notification.description = @issueActivities.user.username+' has '+@comment+' the issue assigned by you.'
      @notification.issueId = @issue.id
      @notification.save
    end

    respond_to do |format|
      format.json {render json: @issue, status: :ok}
    end
  end

  def delete_comment
    @issue = Issue.find(params[:id])
    @commentId = params[:commentId]
    
    @issueComment = IssueComment.find(@commentId)

    if session[:usertype]== 2
      @projectsArr = [];
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
      if not @projectsArr.include?(@issueComment.issue.projectId)
        render json: {status:0,message:"Access Denied"}, status: :unprocessable_entity
        return
      end
    end

    if session[:usertype] == 3 || session[:usertype] == 4
      if session[:user_id] !=  @issueComment.userId
          render json: {status:0,message:"Access Denied"}, status: :unprocessable_entity
          return
      end
    end
    
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

    if session[:usertype]== 2
      @projectsArr = [];
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
      if not @projectsArr.include?(@issueChecklist.issue.projectId)
        render json: {status:0,message:"Access Denied"}, status: :unprocessable_entity
        return
      end
    end

    if session[:usertype] == 3 || session[:usertype] == 4
      if session[:user_id] !=  @issueChecklist.user_id
          render json: {status:0,message:"Access Denied"}, status: :unprocessable_entity
          return
      end
    end

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

    if session[:usertype]== 2
      @projectsArr = [];
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
      if not @projectsArr.include?(@issueImage.issue.projectId)
        render json: {status:0,message:"Access Denied"}, status: :unprocessable_entity
        return
      end
    end

    if session[:usertype] == 3 || session[:usertype] == 4
      if session[:user_id] !=  @issueImage.userId
          render json: {status:0,message:"Access Denied"}, status: :unprocessable_entity
          return
      end
    end
    
    @issueActivities = IssueActivity.new
    @issueActivities.issue_id = @issueImage.issueId
    @issueActivities.user_id = @issueImage.userId
    @issueActivities.description = 'deleted an attachment'
    @issueActivities.save

    #@issueImage.destroy
    @issueImage.attributes = {is_deleted:1}
    @issueImage.save(validate: false)

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
      params.require(:issue).permit(:projectId, :issueTypeId, :summary, :priorityTypeId, :dueDate, :assignee, :environment, :description, :originalEstimate, :remainEstimate, :boardId)
    end

    def prepare_priority_type
      @priorityTypes = PriorityType.all
    end

    def prepare_user_list
      @users = User.where(is_deleted: 0).all
      @users = @users.where.not(usertype: '1')
      @users = @users.where("usertype IN (3,4)") if session[:usertype]== 3 || session[:usertype]== 4
    end
    
    def prepare_issue_type
      @issueTypes = IssueType.all
    end
    
    def prepare_project_list
      @projectsArr = [];
      if session[:usertype]== 2
        @userProjects = UserProject.where(userId:session[:user_id])
        @userProjects.each do |up|
          @projectsArr.push(up.projectId)
        end
      elsif session[:usertype] == 3 || session[:usertype] == 4
        @userIssues = Issue.where(:assignee => session[:user_id]).group('projectId')
        @userIssues.each do |ui|
          @projectsArr.push(ui.projectId)
        end
      end
      @projects = Project.all
      @projects = @projects.where(:id => @projectsArr) if session[:usertype] != 1
    end

    def check_permission
      if session[:usertype]==3
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      elsif session[:usertype]==4
        flash[:danger] = "Access Denied."
        redirect_to issues_url
      end
    end

end
