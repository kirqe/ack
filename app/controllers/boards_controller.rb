class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def new
    @board = Board.new(board_params)
  end
  
  def create

  end

  private
    def board_params
      params.require(:board).permint(:name, :slug, :body)
    end
end
