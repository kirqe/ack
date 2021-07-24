class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  def index
    locals = {
      commentable: @commentable 
    }

    if params[:comment_id]
      @comment = Comment.find(params[:comment_id])

      locals = {
        commentable: @comment.commentable, 
        comment: @comment
      }
    end

    respond_to do |format|
      format.html
      format.json {
        render json: {
          comments: render_to_string("comments/_comments", formats: [:html], layout: false,
            locals: locals)
        }
      }
    end 
  end

  def replies
    @comment = Comment.find(params[:comment_id])    
 
    respond_to do |format|
      format.html
      format.json {
        render json: {
          replies: render_to_string("comments/_replies", formats: [:html], layout: false,
            locals: { 
              commentable: @comment.commentable, 
              comment: @comment
            })
        }
      }
    end
  end  

  def create
    comment = ActiveDecorator::Decorator.instance.decorate(@commentable.comments.new(comment_params))
    comment.user = current_user

    form_to_render = comment.parent_id.nil? ? "comments/_form" : "comments/_reply_form"

    if comment.save
      render json: render_to_string("comments/_comment", formats: [:html], layout: false, 
        locals: { 
          commentable: @commentable, 
          comment: comment 
        })
    else
      render json: {
        formWithErrors: render_to_string(form_to_render, formats: [:html], layout: false, 
          locals: { 
            commentable: @commentable, 
            comment: comment
          })
        }, status: :unprocessable_entity 
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :parent_id, files: [])
    end
end