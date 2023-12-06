class BoardsController < ApplicationController
  before_action :logged_in_user
  add_breadcrumb "Board", :boards_path

  before_action :set_board, only: [:show, :edit, :update, :destroy]
  before_action :prepare_project_list

  before_action :check_permission, only: [:new, :edit, :update, :destroy]

  # GET /boards
  # GET /boards.json
  def index
    add_breadcrumb "index", boards_path

    @projectsArr = [];
    if session[:usertype]== 2
      @userProjects = UserProject.where(userId:session[:user_id])
      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end
    end

    if params[:search]
      wildcard_search = "%#{params[:search]}%"
      @boards = Board.paginate(page: params[:page])
                     .left_joins(:project)
                     .left_joins(:board_issue)
                     .joins("LEFT JOIN issues ON board_issues.issueId = issues.id")
                     .where("boards.is_deleted = 0 AND (boards.boardName LIKE :search OR projects.projectName LIKE :search)",search: wildcard_search)
                     .order('boards.id DESC')
                     .group('boards.id')
      @boards = @boards.where(:projectId => @projectsArr) if session[:usertype]== 2

      @boards = @boards.where(issues:{:assignee => session[:user_id]}) if session[:usertype]== 3 || session[:usertype]== 4
    else
      @boards = Board.paginate(page: params[:page])
                     .left_joins(:project)
                     .left_joins(:board_issues)
                     .joins("LEFT JOIN issues ON board_issues.issueId = issues.id")
                     .where("boards.is_deleted = 0")
                     .order('boards.id DESC')
                     .group('boards.id')
      @boards = @boards.where(:projectId => @projectsArr) if session[:usertype]== 2

      @boards = @boards.where(issues:{:assignee => session[:user_id]}) if session[:usertype]== 3 || session[:usertype]== 4
    end 
  end

  # GET /boards/1
  # GET /boards/1.json
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
      if not @projectsArr.include?(@board.projectId)
        flash[:danger] = "Access Denied."
        redirect_to boards_url
      end
    end
    add_breadcrumb @board.id
  end

  # GET /boards/new
  def new
    add_breadcrumb "New"
    @board = Board.new
  end

  # GET /boards/1/edit
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
      if not @projectsArr.include?(@board.projectId)
        flash[:danger] = "Access Denied."
        redirect_to boards_url
      end
    end
    add_breadcrumb @board.id, board_path
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(board_params)
    @board.createdAt = Time.now
    @board.updatedAt = Time.now

    respond_to do |format|
      if @board.save
        format.html { redirect_to @board, notice: 'Board was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /boards/1
  # PATCH/PUT /boards/1.json
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
      if not @projectsArr.include?(@board.projectId)
        flash[:danger] = "Access Denied."
        redirect_to boards_url
      end
    end
    @board = Board.find(params[:id])
    @board.updateTime = Time.now
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    #@board.destroy
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
      if not @projectsArr.include?(@board.projectId)
        flash[:danger] = "Access Denied."
        redirect_to boards_url
      end
    end
    @board.attributes = {is_deleted:1}
    @board.save(validate: false)
    respond_to do |format|
      format.html { redirect_to boards_url, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def quick_create
    @board = Board.new
    render :layout => false 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:projectId, :boardName)
    end

    def prepare_project_list
      @projectsArr = [];
      if session[:usertype]== 2
        @userProjects = UserProject.where(userId:session[:user_id])
        @userProjects.each do |up|
          @projectsArr.push(up.projectId)
        end
      end
      @projects = Project.all
      @projects = @projects.where(:id => @projectsArr) if session[:usertype]== 2
    end

    def check_permission
      if session[:usertype]==3
        flash[:danger] = "Access Denied."
        redirect_to boards_url
      elsif session[:usertype]==4
        flash[:danger] = "Access Denied."
        redirect_to boards_url
      end
    end

end
