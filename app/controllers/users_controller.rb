class UsersController < ApplicationController
  before_action :logged_in_user
  add_breadcrumb "User", :users_path

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :prepare_user_type_list

  # GET /users
  # GET /users.json
  def index
    add_breadcrumb "index", users_path
    if params[:search]
      search = "%#{params[:search]}%"
      wildcard_search = search.strip

      @users = User.paginate(page: params[:page])
                    .joins(:userType)
                    .where("users.is_deleted = 0 AND (users.username LIKE :search OR users.email LIKE :search OR user_types.userTypeName LIKE :search)",search: wildcard_search)
                    .order('users.id DESC')
    else
      @users = User.paginate(page: params[:page]).where(:is_deleted => 0).order('id DESC')
    end
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
    @user.createTime = Time.now
    @user.updateTime = Time.now
    @user.createUserId = session[:user_id];
    @user.updateUserId = session[:user_id];

    respond_to do |format|
      #@user.password = params[:password]
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
    @user.updateUserId = session[:user_id];
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
    #@user.destroy
    @user.attributes = {is_deleted:1}
    @user.save(validate: false)
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
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :usertype, :createTime, :updateTime)
    end

    def prepare_user_type_list
      @usertypes = UserType.all
    end
end
