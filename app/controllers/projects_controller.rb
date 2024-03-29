class ProjectsController < ApplicationController
  before_action :logged_in_user
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :prepare_priority_type
  before_action :prepare_user_list

  before_action :check_permission, only: [:new, :edit, :update, :destroy]

  add_breadcrumb "Project", :projects_path
  # GET /projects
  # GET /projects.json
  def index
    add_breadcrumb "List", projects_path
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

    if params[:search]
      wildcard_search = "%#{params[:search]}%"
      @projects = Project.paginate(page: params[:page])
                         .joins(:priorityType)
                         .where("projects.is_deleted = 0 AND (projectName LIKE :search OR projectKey LIKE :search OR projectLeader LIKE :search OR priority_types.priorityTypeName LIKE :search)", search: wildcard_search)
                         .order('projects.id DESC')
      @projects = @projects.where(:id => @projectsArr) if session[:usertype]!= 1
    else
      @projects = Project.paginate(page: params[:page])
                          .where(:is_deleted => 0)
                          .order('id DESC')
      @projects = @projects.where(:id => @projectsArr) if session[:usertype]!= 1
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
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
    if session[:usertype]!= 1
      if not @projectsArr.include?(@project.id)
        flash[:danger] = "Access Denied."
        redirect_to projects_url
      end
    end
    add_breadcrumb @project.projectName
  end

  # GET /projects/new
  def new
    add_breadcrumb "New"
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
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
    if session[:usertype]!= 1
      if not @projectsArr.include?(@project.id)
        flash[:danger] = "Access Denied."
        redirect_to projects_url
      end
    end
    add_breadcrumb @project.projectName, project_path
    add_breadcrumb "Update"
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.time = Time.now

    respond_to do |format|
      if @project.save

        @userProject = UserProject.new()
        @userProject.projectId = @project.id
        @userProject.userId = params[:project][:projectLeader]
        @userProject.created_at = Time.now
        @userProject.updated_at = Time.now
        @userProject.save

        @notification = Notification.new
        @notification.created_at = Time.now
        @notification.updated_at = Time.now
        @notification.userId = params[:project][:projectLeader]
        @notification.projectId = @project.id
        @notification.description = "Project "+@project.projectName+" assigned to you."
        @notification.save

        AppMailer.user_project_email(@userProject, session).deliver

        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
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
    if session[:usertype]!= 1
      if not @projectsArr.include?(@project.id)
        flash[:danger] = "Access Denied."
        redirect_to projects_url
      end
    end
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    #@project.destroy
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
    if session[:usertype]!= 1
      if not @projectsArr.include?(@project.id)
        flash[:danger] = "Access Denied."
        redirect_to projects_url
      end
    end
    @project.attributes = {is_deleted:1}
    @project.save(validate: false)
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:projectName, :projectKey, :projectLeader, :projectPriority, :projectDetails)
    end

    def prepare_priority_type
      @priorityTypes = PriorityType.all
    end

    def prepare_user_list
      @leaders = User.where(usertype: '2').all
    end

    def check_permission
      if session[:usertype]==3
        flash[:danger] = "Access Denied."
        redirect_to projects_url
      elsif session[:usertype]==4
        flash[:danger] = "Access Denied."
        redirect_to projects_url
      end
    end

end
