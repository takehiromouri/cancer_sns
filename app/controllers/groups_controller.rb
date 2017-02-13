class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_moderator!, only: [:edit, :update]

  def index
    @my_groups = current_user.groups

    if params[:group_search] && params[:group_search][:keyword]   
    
      @groups = Group.search(params[:group_search][:keyword])
    end

    @group_search = GroupSearch.new(params[:group_search])
  end

  def show
    @group = find_group
    @posts = @group.group_posts.includes(:user, :post_images).paginate(page: params[:page], per_page: 5).decorate
    @post = GroupPost.new
    @post_images = @post.post_images.build
    @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
    @unread_group_posts =  GroupPost.unread_by(current_user).includes(:user, :group)

    mark_posts_as_read
  end

  def new
    @group = Group.new

    @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
  end

  def create
    @group = Group.new(group_params)

    if @group.save && current_user.group_memberships.create(group_id: @group.id, role: :moderator)
      flash[:success] = "グループが作成されました。"
      redirect_to group_path(@group)
    else
      flash[:alert] = @group.errors.full_messages[0]
      render :new
    end
  end

  def edit
    @group = find_group
    @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
    @unread_group_posts =  GroupPost.unread_by(current_user).includes(:user, :group)
  end

  def update
    @group = find_group
    if @group.update(group_params)
      flash[:success] = "グループ情報が更新されました。"
      redirect_to group_path(@group)
    else
      flash[:alert] = @group.errors.full_messages[0]

      @unread_messages = Message.unread_by(current_user).includes(chat_room: [:user, :member, :messages])
      @unread_group_posts =  GroupPost.unread_by(current_user).includes(:user, :group)

      render :edit
    end
  end

  private

  def find_group
    @group ||= Group.find(params[:id])
  end

  def ensure_moderator!
    @group = find_group
    group_membership = current_user.group_memberships.find_by(group: @group)
    return if group_membership.moderator?
    flash[:alert] = "グループ管理者以外編集できません。"
    redirect_to group_path(@group)
  end

  def mark_posts_as_read
    @group.group_posts.mark_as_read! :all, for: current_user
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
