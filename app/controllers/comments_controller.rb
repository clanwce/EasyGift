class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @comment = Comment.new(user_id: current_user.id, description: params[:comment]["description"], gift_request_id: params[:comment]["gift_request_id"])
    gift_requests = @comment.gift_request
    respond_to do |format|
      if @comment.save
        format.html { redirect_to gift_requests, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html {
          redirect_to gift_requests, notice: @comment.errors.full_messages.to_sentence 
        }
        format.json { render json: @comment.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  def final
    @comment = Comment.find(params[:comment_id])
    if @comment
      @comment_gift_request = @comment.gift_request
      respond_to do |format|
        if current_user.id == @comment_gift_request.user.id && current_user.id != @comment.user.id && @comment.update_attributes(final_answer: true)
          format.html { redirect_to @comment_gift_request, notice: 'Final answer was chosen'}
          format.json { render json: @comment, status: :created}
        else
          format.html { 
            unless current_user.id == @comment_gift_request.user.id
              @comment.errors[:base ] << "Unauthorized final answer"
            end
            unless current_user.id != @comment.user.id
              @comment.errors[:base ] << "Can't select your own gift comment as final answer"
            end
            redirect_to @comment_gift_request, notice: @comment.errors.full_messages.to_sentence
          }
          format.json { render json: @comment.errors.full_messages.to_sentence, status: :unprocessable_entity }      
        end
      end
    end
  end

  def likes
    @commentu = Array.new
    @comment = Comment.find(params[:id])
    @status = params[:status]
    @comment.likes.each do |like|
      if like.status == @status
      @commentu.push(like.user_id => like.username)
      end
    end
    #@commentu = {:comment => @comment.likes.as_json , :user => @commentu}
    render json: @commentu
  end

end

