class LikesController < ApplicationController
	before_filter :authenticate_user!
	
	def create
		@like = Like.new(params[:like])
		if @like.gift_request
			type = "gift_request"
			post_or_comment = @like.gift_request
			gift_request = @like.gift_request
		else
			type = "comment"
			post_or_comment = @like.comment
			gift_request = @like.comment_gift_request
		end
	    respond_to do |format|
	      if current_user.id != post_or_comment.user.id && @like.save
	      	format.html {
	   			@like.update_gift_request_or_comment(@like.status, type)
		        redirect_to gift_request, notice: 'Like Sucessful' 
	      	}
	      	format.json {
	      		result = {}
	      		result[:like] = @like
	      		result[:status] = true	 
	      		render json: result
	      	}
	      else
	        format.html {
				if current_user.id == post_or_comment.user.id
					@like.errors += "Can't like your own comment or post"
				end
	        		redirect_to gift_request, notice: @like.errors.full_messages.to_sentence
	        }
	        format.json { render json: @like.errors.full_messages.to_sentence, status: :unprocessable_entity } 
	      		# result = {}
	      		# result[:errors] = @like.errors.full_messages.to_sentence
	      		# result[:status] = false	 
	      		# render json: result  
	        # }
	      end
	    end
	end

end
