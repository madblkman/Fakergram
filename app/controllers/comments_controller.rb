class CommentsController < ApplicationController
  before_action :find_post

  def index
    @comments = @post.comments.all.order("created_at DESC")

    respond_to do |format|
      format.html
      format.json {render json: @comments}
      format.js
    end
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    else
      flash[:alert] = "Check the comment form, something went wrong"
      render root_path
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to root_path }
        format.json { head :ok }
      else
        flash[:alert] = "Something went wrong!"
      end
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def find_post
    @post = Post.find(params[:post_id])
  end
end
