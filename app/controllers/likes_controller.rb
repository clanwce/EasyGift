class LikesController < ApplicationController
	before_filter :authenticate_user!
	def create
		@like = Like.new(params[:like])
	    respond_to do |format|
	      if @like.save
	      	format.html {
	      	if @like.gift_request
	   			@like.update_gift_request_likes(@like.status)
		        redirect_to @like.gift_request, notice: 'Like Sucessful' 
		    else
		    	@like.update_comment_likes(@like.status)
		    	redirect_to @like.comment.gift_request, notice: 'Like Successful'	    	
		    end
	      	}
	      	format.json {
	      		result = {}
	      		result[:like] = @like
	      		result[:status] = true	 
	      		render json: result
	      	}
	      else
	        format.html {
	        	notice = ''
	        	@like.errors.full_messages.each do |message|
				    notice += message
				end
	        	if @like.gift_request
	        		redirect_to @like.gift_request, notice: notice
	        	else
	        		redirect_to @like.comment.gift_request, notice: notice
	        	end
	        }
	        format.json {
	      		result = {}
	      		result[:errors] = @like.errors
	      		result[:status] = false	 
	      		render json: result  
	        }
	      end
	    end
	end

end
