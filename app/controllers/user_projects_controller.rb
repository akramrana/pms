class UserProjectsController < ApplicationController

  before_action :logged_in_user
  before_action :set_user_project, only: [:show, :edit, :update, :destroy]

  before_action :prepare_user_list

  def index
    @user_projects = UserProject.all
  end

  def show
  end

  def new
    @user_project = UserProject.new
  end

  def edit
  end

  def create
    @user_project = UserProject.new(user_project_params)
    @user_project.created_at = Time.now
    @user_project.updated_at = Time.now
    respond_to do |format|
      if @user_project.save
        format.html { redirect_to @user_project, notice: 'Project successfully assigned.' }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def destroy
    @user_project.destroy
    respond_to do |format|
      format.html { redirect_to user_projects_url, notice: 'Project was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def quick_create
    @userProject = UserProject.new
    render :layout => false 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_project
      @user_project = UserProject.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_project_params
      params.require(:user_project).permit(:projectId, :userId)
    end

    def prepare_user_list
      @users = User.where(usertype: '2').all
    end

end
