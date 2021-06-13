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
        format.js {  render partial: "posts/post.json", 
                            locals: { post: @post }, 
                            notice: "Post was successfully created.", 
                            content_type: "application/json" }        
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js {  render :new, status: :unprocessable_entity, content_type: "text" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
    
    def set_board
      @board = Board.find_by(slug: params[:board_id])
    end

    def post_params
      params.require(:post).permit(:name, :url, :body)
    end
end
