class ConversationsController < ApplicationController
  def index
    @conversations = current_user.show_all_conversations
  end

  def show
      conversation = Conversation.find(params[:id])
      if conversation.users.find_by_id(current_user.id)
        @other_user = conversation.users.where("user_id != #{current_user.id}").first
        @messages = conversation.show_messages(current_user.id)
      else
        redirect_to "/"
      end
  end

  def create
    @other_user = User.find(params[:id])
    message = params[:message]
    conversation = current_user.send_private_message(@other_user.id, message)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: conversation }
    end
  end

  def delete
    conversation_id = params[:id]
    current_user.delete_conversation(conversation_id)
  end

  def mark_as_read
    conversation = Conversation.find(params[:id])
    conversation.mark_as_read(current_user.id)
  end

  def mark_as_unread
    conversation = Conversation.find(params[:id])
    conversation.mark_as_unread(current_user.id)
  end
end
