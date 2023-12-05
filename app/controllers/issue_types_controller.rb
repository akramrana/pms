class IssueTypesController < ApplicationController
  before_action :logged_in_user, :admin_only
  before_action :set_issue_type, only: [:show, :edit, :update, :destroy]

  add_breadcrumb "Issue Type", :issue_types_path
  # GET /issue_types
  # GET /issue_types.json
  def index
    add_breadcrumb "List", issue_types_path
    @issue_types = IssueType.where(:is_deleted => 0).all
  end

  # GET /issue_types/1
  # GET /issue_types/1.json
  def show
    add_breadcrumb @issue_type.issueTypeName
  end

  # GET /issue_types/new
  def new
    add_breadcrumb "New"
    @issue_type = IssueType.new
  end

  # GET /issue_types/1/edit
  def edit
    add_breadcrumb @issue_type.issueTypeName, issue_type_path
    add_breadcrumb "Update"
  end

  # POST /issue_types
  # POST /issue_types.json
  def create
    @issue_type = IssueType.new(issue_type_params)

    respond_to do |format|
      if @issue_type.save
        format.html { redirect_to @issue_type, notice: 'Issue type was successfully created.' }
        format.json { render :show, status: :created, location: @issue_type }
      else
        format.html { render :new }
        format.json { render json: @issue_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issue_types/1
  # PATCH/PUT /issue_types/1.json
  def update
    respond_to do |format|
      if @issue_type.update(issue_type_params)
        format.html { redirect_to @issue_type, notice: 'Issue type was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue_type }
      else
        format.html { render :edit }
        format.json { render json: @issue_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_types/1
  # DELETE /issue_types/1.json
  def destroy
    #@issue_type.destroy
    @issue_type.attributes = {is_deleted:1}
    @issue_type.save(validate: false)
    respond_to do |format|
      format.html { redirect_to issue_types_url, notice: 'Issue type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_type
      @issue_type = IssueType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_type_params
      params.require(:issue_type).permit(:issueTypeName)
    end
end
