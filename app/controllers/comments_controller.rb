class CommentsController < ApplicationController

  def create
    @comment = Comment.new(params[:comment])
    gift_requests = @comment.gift_request
    respond_to do |format|
      if @comment.save
        format.html { redirect_to gift_requests, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to gift_requests, notice: 'Failed to create comment.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
end

