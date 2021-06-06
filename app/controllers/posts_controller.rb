class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.newest_first
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    set_user
    @post = Post.new(post_params)
    @post.user = current_user
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:name, :url, :body)
    end
end
