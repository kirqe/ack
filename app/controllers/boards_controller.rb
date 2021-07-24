class BoardsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @boards = Board.approved.ordered_by_post_count
  end

  def new
    @board = Board.new
  end
  
  def create
    @board = Board.new(board_params)
    if @board.save        
      redirect_to boards_url, notice: "The board was successfully created. Wait till it's approved"
    else        
      render json: {
        formWithErrors: render_to_string("boards/_form", formats: [:html], layout: false, locals: { board: @board })
      }, status: :unprocessable_entity         
    end      
  end

  private
    def board_params
      params.require(:board).permit(:name, :slug, :body)
    end
end
