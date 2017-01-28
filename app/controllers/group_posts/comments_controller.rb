class GroupPosts::CommentsController < ApplicationController
  def create
    @post = GroupPost.find(params[:group_post_id])
    @comment = @post.comments.create(comment_params)
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end
end
