class ProjectTypesController < ApplicationController
  before_action :set_project_type, only: [:show, :edit, :update, :destroy]

  add_breadcrumb "Project Type", :project_types_path
  # GET /project_types
  # GET /project_types.json
  def index
    add_breadcrumb "List", project_types_path
    @project_types = ProjectType.where(:is_deleted => 0).all
  end

  # GET /project_types/1
  # GET /project_types/1.json
  def show
    add_breadcrumb @project_type.typeName
  end

  # GET /project_types/new
  def new
    add_breadcrumb "New"
    @project_type = ProjectType.new
  end

  # GET /project_types/1/edit
  def edit
    add_breadcrumb @project_type.typeName, project_type_path
    add_breadcrumb "Update"
  end

  # POST /project_types
  # POST /project_types.json
  def create
    @project_type = ProjectType.new(project_type_params)

    respond_to do |format|
      if @project_type.save
        format.html { redirect_to @project_type, notice: 'Project type was successfully created.' }
        format.json { render :show, status: :created, location: @project_type }
      else
        format.html { render :new }
        format.json { render json: @project_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_types/1
  # PATCH/PUT /project_types/1.json
  def update
    respond_to do |format|
      if @project_type.update(project_type_params)
        format.html { redirect_to @project_type, notice: 'Project type was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_type }
      else
        format.html { render :edit }
        format.json { render json: @project_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_types/1
  # DELETE /project_types/1.json
  def destroy
    #@project_type.
    @project_type.attributes = {is_deleted:1}
    @project_type.save(validate: false)
    respond_to do |format|
      format.html { redirect_to project_types_url, notice: 'Project type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_type
      @project_type = ProjectType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_type_params
      params.require(:project_type).permit(:typeName)
    end
end
