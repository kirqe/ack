class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.newest_first
    @post = Post.new
  end

  def show
  end

  def create
    set_user unless token_exists?
    @post = Post.new(post_params)
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

    def post_params
      params.require(:post).permit(:name, :url, :body)
    end
end
