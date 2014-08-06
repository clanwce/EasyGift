class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index

    @tags = Kaminari.paginate_array(Tag.all).page(params[:page]).per(36)
    #@tags = Tag.order('lower(name)').all

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

    if(params[:filter].nil?)
      @tag_gift_request = @tag.gift_requests.order('gift_requests.created_at DESC').page(params[:page]).per(10)
    elsif params[:filter] == "popular"
      @tag_gift_request = @tag.gift_requests.popular.page(params[:page]).per(10)
    elsif params[:filter] == "top"
      @tag_gift_request = @tag.gift_requests.top.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

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

    all_tags = Tag.all

    require 'fuzzystringmatch'
    jarow = FuzzyStringMatch::JaroWinkler.create( :native )
    all_tags.each do |tag|
        if(jarow.getDistance( tag.name.downcase, keyword.downcase ) > 0.8)
          @tags << tag
        end
    end
    respond_to do |format|
      format.json { 
        render json: @tags
      }
    end
  end

  def tag_subscribe
    tagid = params[:tag_id]
    f = current_user.subscribe_tags(tagid)
    if f==true
        result={}
        result["id"]=tagid
        result["flag"]=true   
        render json: result     
    else
        result={}
        result["id"]=tagid
        result["flag"]=false
        render json: result
    end
  end

  def tag_unsubscribe
    tagid = params[:tag_id]
    f = current_user.unsubscribe_tags(tagid)
    if f==true
        result={}
        result["id"]=tagid
        result["flag"]=true   
        render json: result     
    else
        result={}
        result["id"]=tagid
        result["flag"]=false
        render json: result
    end
  end

end
