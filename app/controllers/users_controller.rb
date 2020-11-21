class UsersController < ApplicationController

  add_breadcrumb "User", :users_path

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :prepare_user_type_list

  # GET /users
  # GET /users.json
  def index
    add_breadcrumb "index", users_path
    @users = User.order('id DESC').all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    add_breadcrumb @user.id
  end

  # GET /users/new
  def new
    add_breadcrumb "New"
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    add_breadcrumb @user.id, user_path
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    @user.createTime = Time.now
    @user.updateTime = Time.now

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @user.updateTime = Time.now
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :usertype, :createTime, :updateTime)
    end

    def prepare_user_type_list
      @usertypes = UserType.all
    end
end
