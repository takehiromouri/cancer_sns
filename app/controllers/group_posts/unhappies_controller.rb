class GroupPosts::UnhappiesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = GroupPost.find(params[:group_post_id])    
    current_user.unhappy(@post)

    @post.reload

    respond_to do |format|
      format.js {}
    end   
  end

end