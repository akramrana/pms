class PriorityTypesController < ApplicationController
  before_action :logged_in_user
  before_action :set_priority_type, only: [:show, :edit, :update, :destroy]

  add_breadcrumb "Priority Type", :priority_types_path
  # GET /priority_types
  # GET /priority_types.json
  def index
    add_breadcrumb "List", priority_types_path
    @priority_types = PriorityType.where(:is_deleted => 0).all
  end

  # GET /priority_types/1
  # GET /priority_types/1.json
  def show
    add_breadcrumb @priority_type.priorityTypeName
  end

  # GET /priority_types/new
  def new
    add_breadcrumb "New"
    @priority_type = PriorityType.new
  end

  # GET /priority_types/1/edit
  def edit
    add_breadcrumb @priority_type.priorityTypeName, priority_type_path
    add_breadcrumb "Update"
  end

  # POST /priority_types
  # POST /priority_types.json
  def create
    @priority_type = PriorityType.new(priority_type_params)

    respond_to do |format|
      if @priority_type.save
        format.html { redirect_to @priority_type, notice: 'Priority type was successfully created.' }
        format.json { render :show, status: :created, location: @priority_type }
      else
        format.html { render :new }
        format.json { render json: @priority_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /priority_types/1
  # PATCH/PUT /priority_types/1.json
  def update
    respond_to do |format|
      if @priority_type.update(priority_type_params)
        format.html { redirect_to @priority_type, notice: 'Priority type was successfully updated.' }
        format.json { render :show, status: :ok, location: @priority_type }
      else
        format.html { render :edit }
        format.json { render json: @priority_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /priority_types/1
  # DELETE /priority_types/1.json
  def destroy
    #@priority_type.destroy
    @priority_type.attributes = {is_deleted:1}
    @priority_type.save(validate: false)

    respond_to do |format|
      format.html { redirect_to priority_types_url, notice: 'Priority type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_priority_type
      @priority_type = PriorityType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def priority_type_params
      params.require(:priority_type).permit(:priorityTypeName)
    end
end
