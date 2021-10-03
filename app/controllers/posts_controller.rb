# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_post, only: [:show]
  before_action :set_board, only: [:index]

  def index
    @pagy, @posts = pagy(@board.posts.pinned_first.recently_active.top_rated.newest_first)
    @posts = policy_scope(@posts)

    @posts = @posts.locked if params[:filter] == 'locked'
    @posts = @posts.hidden if params[:filter] == 'hidden'
    @posts = @posts.soft_deleted if params[:filter] == 'deleted'
    @posts = @posts.simple_search(params[:q]) if params[:q]

    @post = @board.posts.new

    respond_to do |format|
      format.html
      format.json do
        render json: {
          posts: render_to_string(@posts, formats: [:html]),
          pagination: view_context.pagy_nav(@pagy)
        }
      end
    end
  end

  def show; end

  def create
    @board = Board.find(params[:board_id])
    @post = @board.posts.new(post_params)
    @post.user = current_user

    authorize @post

    if @post.save
      render json: render_to_string('posts/_post', layout: false, locals: { post: @post })
    else
      render json: {
        formWithErrors: render_to_string('posts/_form', formats: [:html], layout: false, locals: { post: @post })
      }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = authorize(Post.includes(user: :comments).friendly.find(params[:id]))
  end

  def set_board
    @board = Board.includes(:posts).find_by(slug: params[:board_id])
    raise ActiveRecord::RecordNotFound unless @board
  end

  def post_params
    params.require(:post).permit(:name, :url, :body, :rendered_body, files: [])
  end
end
