# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @boards = policy_scope(Board.ordered_by_post_count)

    @boards = @boards.approved     if params[:filter] == 'approved' || params[:filter].nil?
    @boards = @boards.pending      if params[:filter] == 'pending'
    @boards = @boards.rejected     if params[:filter] == 'rejected'
    @boards = @boards.soft_deleted if params[:filter] == 'deleted'
  end

  def new
    @board = Board.new
    authorize @board
  end

  def create
    @board = authorize(Board.new(board_params))

    if @board.save
      redirect_to boards_url, notice: "The board was successfully created. Wait till it's approved."
    else
      render json: {
        formWithErrors: render_to_string('boards/_form', formats: [:html], layout: false, locals: { board: @board })
      }, status: :unprocessable_entity
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :slug, :body)
  end
end
