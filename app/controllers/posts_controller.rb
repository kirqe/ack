class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show]
  before_action :set_board, only: [:index, :create]

  def index
    @pagy, @posts = pagy(@board.posts.newest_first)
    @post = @board.posts.new

    respond_to do |format|
      format.html
      format.json {
        render json: { posts: render_to_string(@posts, formats: [:html] ), pagination: view_context.pagy_nav(@pagy)}
      }
    end
  end

  def show
  end

  def create
    @post = @board.posts.new(post_params)
    @post.user = current_user

    if @post.save
      render json: render_to_string('posts/_post', layout: false, locals: { post: @post })       
    else    
      render json: { 
        formWithErrors: render_to_string("posts/_form", formats: [:html], layout: false, locals: {post: @post} ) 
      }, status: :unprocessable_entity       
    end
  end

  private
    def set_post
      @post = Post.includes(user: :comments).friendly.find(params[:id])
    end
    
    def set_board     
      @board = Board.includes(:posts).find_by(slug: params[:board_id])
      redirect_to boards_url, notice: "This board is not approved yet." unless @board.approved?
    end

    def post_params
      params.require(:post).permit(:name, :url, :body, :rendered_body, files: [])
    end
end


