# frozen_string_literal: true

module Admin
  class PostsController < Admin::AdminController
    before_action :set_post

    def pin
      if @post.pinned?
        @post.unpin!
        flash[:notice] = "#{@post.name} was successfully unpinned."
      else
        @post.pin!
        flash[:notice] = "#{@post.name} was successfully pinned."
      end

      redirect_to board_posts_path(@post.board.slug)
    end

    def lock
      if @post.locked?
        @post.unlock!
        flash[:notice] = "#{@post.name} was successfully unlocked."
      else
        @post.lock!
        flash[:notice] = "#{@post.name} was successfully locked."
      end

      redirect_to board_posts_path(@post.board.slug)
    end

    def publish
      if @post.published?
        @post.unpublish!
        flash[:notice] = "#{@post.name} was successfully unpublished."
      else
        @post.publish!
        flash[:notice] = "#{@post.name} was successfully publish."
      end

      redirect_to board_posts_path(@post.board.slug)
    end

    def delete
      if @post.soft_deleted?
        @post.restore!
        flash[:notice] = "#{@post.name} was successfully restored"
      else
        @post.soft_delete!

        if params[:suspend]
          @post.user.suspend!
          notice = "And #{@post.user.username} suspended."
        elsif params[:ban]
          @post.user.suspend!(100_000)
          notice = "And #{@post.user.username} banned."
        end

        flash[:notice] = "#{@post.name} was successfully soft deleted." + " #{notice}"
      end

      redirect_to board_posts_path(@post.board.slug)
    end

    def set_post
      @post = Post.friendly.find(params[:id])
      authorize([:admin, @post])
    end
  end
end
