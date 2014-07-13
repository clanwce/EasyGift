class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])
    @tag_gift_request = @tag.gift_requests

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  # def new
  #   @tag = Tag.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @tag }
  #   end
  # end

  # GET /tags/1/edit
  # def edit
  #   @tag = Tag.find(params[:id])
  # end

  # POST /tags
  # POST /tags.json
	def create
	    @tag = Tag.new(params[:tag])
	    respond_to do |format|
	      if @tag.save
	        format.html { redirect_to '/', notice: 'Tag was created successfully' }
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

  def tag_search
    @tags = Array.new
    keyword = params[:keyword]
    # all_gift_requests = GiftRequest.all
    all_tags = Tag.all
    # all_gift_requests.each do |gift_request|
    #   gift_request.title
    # end
    require 'fuzzystringmatch'
    jarow = FuzzyStringMatch::JaroWinkler.create( :native )
    all_tags.each do |tag|
        if(jarow.getDistance( tag.name, keyword ) > 0.8)
          @tags << tag
          #selected_gift_requests = tag.gift_requests
          ###tag.gift_requests.each do |selected_gift_request|
          ###@gift_requests << selected_gift_request
          
        end
    end
    respond_to do |format|
      format.json { 
        render json: @tags
      }
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  # def update
  #   @tag = Tag.find(params[:id])

  #   respond_to do |format|
  #     if @tag.update_attributes(params[:tag])
  #       format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @tag.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /tags/1
  # DELETE /tags/1.json
  # def destroy
  #   @tag = Tag.find(params[:id])
  #   @tag.destroy

  #   respond_to do |format|
  #     format.html { redirect_to tags_url }
  #     format.json { head :no_content }
  #   end
  # end
end
