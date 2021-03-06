class GroupPostsController < ApplicationController
  before_action :ensure_owner, only: [:edit, :update, :destroy]
  before_action :authenticate_user!  

  def show
    @post = GroupPost.find(params[:id])
    @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
  end

  def create
    @group = Group.find(params[:group_id])
    @post = current_user.group_posts.new(group_post_params.merge(group_id: @group.id))

    respond_to do |format|      
      if @post.save
        if params[:post_images]
          params[:post_images]['photo'].each do |a|
            @post_image = @post.post_images.create!(photo: a, user_id: current_user.id)
          end
        end
        if group_post_params[:post_taggings_attributes] 
          group_post_params[:post_taggings_attributes]["0"]["post_tag_id"].each do |id|
            @post.post_taggings.create(post_tag_id: id)
          end
        end
        format.js {}
      else
        flash[:alert] = @post.errors.full_messages[0]
        format.js { render 'posts/error' }
      end
    end
  end

  def update    
    @post = GroupPost.find(params[:id])
    update_attachments if params[:post_images]
    @post.update(group_post_params)    
  end

  def destroy
    @post = GroupPost.find(params[:id])
    @post.destroy    
  end

  private

  def group_post_params
    params.require(:group_post).permit(:content, post_images_attributes: [:photo], post_taggings_attributes: [:id, :post_id, :post_type, post_tag_id: []])
  end

  def ensure_owner
    redirect_to group_posts_path if GroupPost.find(params[:id]).user != current_user
  end
  
  def update_attachments
    @post = GroupPost.find(params[:id])
    @post.post_images.each(&:destroy) if @post.post_images.present?
    params[:post_images]['photo'].each do |photo|
      @post_image = @post.post_images.create!(photo: photo, user_id: current_user.id)
    end
  end

end
