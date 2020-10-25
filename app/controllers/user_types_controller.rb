class UserTypesController < ApplicationController
  before_action :set_user_type, only: [:show, :edit, :update, :destroy]

  add_breadcrumb "User Type", :user_types_path
  # GET /user_types
  # GET /user_types.json
  def index
    add_breadcrumb "List", user_types_path
    @user_types = UserType.all
  end

  # GET /user_types/1
  # GET /user_types/1.json
  def show
    add_breadcrumb @user_type.userTypeName
  end

  # GET /user_types/new
  def new
    add_breadcrumb "New"
    @user_type = UserType.new
  end

  # GET /user_types/1/edit
  def edit
    add_breadcrumb @user_type.userTypeName, user_type_path
    add_breadcrumb "Update"
  end

  # POST /user_types
  # POST /user_types.json
  def create
    @user_type = UserType.new(user_type_params)

    respond_to do |format|
      if @user_type.save
        format.html { redirect_to @user_type, notice: 'User type was successfully created.' }
        format.json { render :show, status: :created, location: @user_type }
      else
        format.html { render :new }
        format.json { render json: @user_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_types/1
  # PATCH/PUT /user_types/1.json
  def update
    respond_to do |format|
      if @user_type.update(user_type_params)
        format.html { redirect_to @user_type, notice: 'User type was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_type }
      else
        format.html { render :edit }
        format.json { render json: @user_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_types/1
  # DELETE /user_types/1.json
  def destroy
    @user_type.destroy
    respond_to do |format|
      format.html { redirect_to user_types_url, notice: 'User type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_type
      @user_type = UserType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_type_params
      params.require(:user_type).permit(:userTypeName)
    end
end
