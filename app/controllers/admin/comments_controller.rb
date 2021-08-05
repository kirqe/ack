class Admin::CommentsController < Admin::AdminController
  before_action :set_comment

  def delete
    if @comment.soft_deleted?
      @comment.restore!
      flash[:notice] = "comment ##{@comment.id} was successfully restored"
    else
      @comment.soft_delete!

      if params[:suspend]
        @comment.user.suspend! 
        notice = "And #{@comment.user.username} suspended."
      elsif params[:ban]
        @comment.user.suspend!(36500)
        notice = "And #{@comment.user.username} banned."
      end

      flash[:notice] = "Comment ##{@comment.id} was successfully soft deleted." + " #{notice}"
    end

    redirect_to post_path(@comment.commentable)
  end

  def set_comment
    @comment = Comment.find(params[:id])
    authorize([:admin, @comment])
  end
end