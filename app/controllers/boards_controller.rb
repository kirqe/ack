class BoardsController < ApplicationController
  def index
    @boards = Board.ordered_by_post_count
  end

  def new
    @board = Board.new
  end
  
  def create
    @board = Board.new(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to boards_url, notice: "The board was successfully created. Wait till it's approved" }
        format.js                
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js
        format.json {
          render json: {
            formWithErrors: render_to_string("boards/_form", formats: [:html], layout: false, locals: { board: @board })
          }, status: :unprocessable_entity 
        }
      end  
    end
  end

  private
    def board_params
      params.require(:board).permit(:name, :slug, :body)
    end
end
