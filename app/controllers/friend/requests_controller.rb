class Friend::RequestsController < ApplicationController
	before_action :authenticate_user!
  before_action :check_existing_friendship!
  
  def create
    @user = User.find(params[:user_id])
    current_user.friend_request(@user)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private

  def check_existing_friendship!
    @user = find_user    
    return unless HasFriendship::Friendship.find_by(friend_id: @user.id, friendable_id: current_user.id)
    flash[:alert] = "ユーザーともうすでに友達です。"
    redirect_to root_path
  end

  def find_user
    @user ||= User.find(params[:user_id])
  end
end
