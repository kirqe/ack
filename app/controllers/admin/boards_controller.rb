# frozen_string_literal: true

module Admin
  class BoardsController < Admin::AdminController
    before_action :set_board

    def approve
      @board.approve!
      flash[:notice] = "#{@board.name} was successfully approved."

      redirect_to filtered_boards_path(filter: :approved)
    end

    def reject
      @board.reject!
      flash[:notice] = "#{@board.name} was successfully rejected."

      redirect_to filtered_boards_path(filter: :rejected)
    end

    def delete
      if @board.soft_deleted?
        @board.restore!
        flash[:notice] = "#{@board.name} was successfully restored."
      else
        @board.soft_delete!
        flash[:notice] = "#{@board.name} was successfully deleted."
      end

      redirect_to filtered_boards_path(filter: :deleted)
    end

    def set_board
      # sometimes slug can be messed up... using id
      @board = Board.find(params[:id])
      authorize([:admin, @board])
    end
  end
end
