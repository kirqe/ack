class PostsController < ApplicationController
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
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.js      
        format.json { 
          render json: render_to_string('posts/_post', layout: false, locals: { post: @post }) } 
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js
        format.json { 
          render json: { 
            formWithErrors: render_to_string("posts/_form", formats: [:html], layout: false, locals: {post: @post} ) 
          }, status: :unprocessable_entity 
        }
      end
    end
  end

  private
    def set_post
      @post = Post.includes(user: :comments).find(params[:id])
    end
    
    def set_board
      @board = Board.includes(:posts).find_by(slug: params[:board_id])
    end

    def post_params
      params.require(:post).permit(:name, :url, :body, :rendered_body, files: [])
    end
end


