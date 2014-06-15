class TagsController < ApplicationController


	def create
	    @tag = Tag.new(params[:tag])
	    respond_to do |format|
	      if @tag.save
	        format.html { redirect_to '/', notice: 'Gift request was successfully created.' }
	        format.json { render json: @tag }
	      else
	        format.html { redirect_to '/', notice: @tag.errors.full_messages.to_sentence}
	        format.json { 
	        	@tag = Tag.find_by_name(@tag.name)
	        	render json: @tag 
	        }
	      end
	    end
	end

end