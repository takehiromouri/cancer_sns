class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  layout 'chat_layout'  

  def index
    @chat_room = current_user.chat_rooms.includes(messages: [:user, :chat_room]).most_recent 
    @chat_rooms = current_user.chat_rooms.includes(:member, :user, :messages).select{|chat_room| chat_room != @chat_room}

    if @chat_room.present?
      @messages = @chat_room.messages.reorder(created_at: :desc).includes(chat_room: [:user, :member]).paginate(page: params[:page], per_page: 10)
    end

    @message_search = MessageSearch.new(params[:message_search])
    @message = Message.new

    @other_user = @chat_room.other_user_for(current_user).decorate if @chat_room.present?

    mark_messages_as_read
  end

  def show
    @chat_room = ChatRoom.includes(messages: [:user, :chat_room]).find(params[:id])
    @chat_rooms = current_user.chat_rooms.includes(:member, :user, :messages).select{|chat_room| chat_room != @chat_room}   

    @messages = @chat_room.messages.reorder(created_at: :desc).includes(chat_room: [:user, :member]).paginate(page: params[:page], per_page: 10)

    @message = Message.new   
     
    @message_search = MessageSearch.new(params[:message_search])
    @other_user = @chat_room.other_user_for(current_user).decorate      
    
    mark_messages_as_read
  end

  def create
    user = User.find(params[:user_id])

    if existing_chat_room = ChatRoom.room_with(user, current_user)
      return redirect_to chat_room_path(existing_chat_room)
    end

    @chat_room = ChatRoom.new(member: user, user: current_user)

    if @chat_room.save
      redirect_to chat_room_path(@chat_room)
    else
      flash[:alert] = @chat_room.errors.full_messages[0]
      redirect_to :back
    end
  end

  def load_more    
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages.reorder(created_at: :desc).includes(chat_room: [:user, :member]).paginate(page: params[:page], per_page: 10)
    respond_to do |format|      
      format.js { render layout: false }
    end
  end

  private

  def mark_messages_as_read    
    return if !@chat_room.present? || @chat_room.messages.empty?
    @chat_room.messages.each do |message| 
      message.mark_as_read! for: current_user
      message.set_read_for(user_id: current_user.id)
    end
  end
end