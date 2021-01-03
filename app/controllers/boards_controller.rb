class BoardsController < ApplicationController

  add_breadcrumb "Board", :boards_path

  before_action :set_board, only: [:show, :edit, :update, :destroy]
  before_action :prepare_project_list

  # GET /boards
  # GET /boards.json
  def index
    add_breadcrumb "index", boards_path
    @boards = Board.order('id DESC').all
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    add_breadcrumb @board.id
  end

  # GET /boards/new
  def new
    add_breadcrumb "New"
    @board = Board.new
  end

  # GET /boards/1/edit
  def edit
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
    @board.destroy
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
      @projects = Project.all
    end

end
