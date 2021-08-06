class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    respond_to do |format|
      format.html
      format.json {
        render json: {
          comments: render_to_string("comments/_comments", 
          formats: [:html], 
          layout: false, 
          locals: {             
            comments: @commentable.comments.where(parent_id: nil).order("created_at DESC")
          })
        }
      }
    end   
  end

  def create
    comment = ActiveDecorator::Decorator.instance.decorate(@commentable.comments.new(comment_params))
    comment.user = current_user

    form_to_render = comment.parent_id.nil? ? "comments/_form" : "comments/_reply_form"

    authorize comment

    respond_to do |format|
      if comment.save
        format.html
        format.json {
          render json: render_to_string("comments/_comment", formats: [:html], layout: false, 
            locals: { 
              commentable: @commentable, 
              comment: comment 
            })
        }
      else
        format.html
        format.json {
          render json: {
            formWithErrors: render_to_string(form_to_render, formats: [:html], layout: false, 
              locals: { 
                commentable: @commentable, 
                comment: comment
              })
            }, status: :unprocessable_entity 
        }        
      end
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :parent_id, files: [])
    end
end