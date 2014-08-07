class ConversationsController < ApplicationController
  def index
    @conversations = current_user.show_all_conversations
    
  end

  def show
      conversation = Conversation.find(params[:id])
      if conversation.users.find_by_id(current_user.id)
        @other_user = conversation.users.where("user_id != #{current_user.id}").first
        @messages = conversation.show_messages(current_user.id).reverse
        conversation.mark_as_read(current_user.id)
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
    c = conversation.mark_as_read(current_user.id)
    response = {}
    if c==true
      response['flag'] = true
    else
      response['flag']= false
    end
    render json: response    
  end

  def mark_as_unread
    conversation = Conversation.find(params[:id])
    c = conversation.mark_as_unread(current_user.id)
    response = {}
    if c==true
      response['flag'] = true
    else
      response['flag']= false
    end
    render json: response
  end

  def loadmore
    count = params[:count]
     count = count.to_i
    if (current_user.show_all_conversations.length - count) < 10
      maxcount = current_user.show_all_conversations.length
    else
      maxcount = count + 10
    end
    response = {}
    unreadlist= []
    readlist= []
    unreadarray={}
    readarray={}
    unreadcount = 0
    readcount = 0
    @conversations = current_user.show_all_conversations[count..maxcount]
    @conversations.each do |conversation|
      other_user = conversation.users.where("user_id != #{current_user.id}").first
      if !conversation.is_read?(current_user.id)
        unreadarray['id'] = conversation.id
        unreadarray['username'] = other_user.username
        unreadarray['last_message'] = conversation.last_message.message
       else
        readarray['id'] = conversation.id
        readarray['username'] = other_user.username
        readarray['last_message'] = conversation.last_message.message
      end
      unreadlist << unreadarray
      readlist << readarray
    end
    response['unreadlist'] = unreadlist
    response['readlist'] = readlist
      render json: response
  end 
end
