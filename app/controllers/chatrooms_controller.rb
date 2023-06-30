class ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.where(opened: true) + current_user.chatrooms
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    if @chatroom.opened || @chatroom.users.include?(current_user)
      @authorized = true
      @message = Message.new
      if @chatroom.personal
        @chatroom.users.each do |user|
          @user = user unless user == current_user
        end
      end
    else
      @authorized = false
    end
  end

  def create
    user = User.find(params[:user_id])

    user_chatroom = chatting_with(user)
    if user_chatroom
      redirect_to chatroom_path(user_chatroom)
    else
      chatroom = Chatroom.new
      chatroom.personal = true
      ChatroomUser.create(chatroom: chatroom, user: current_user)
      ChatroomUser.create(chatroom: chatroom, user: user)
      if chatroom.save!
        redirect_to chatroom_path(chatroom)
      end
    end
  end

  private

  def chatting_with(user)
    current_user.chatrooms.where(personal: true).each do |chatroom|
      if chatroom.users.include?(user)
        return chatroom
      end
    end
    return nil
  end
end
