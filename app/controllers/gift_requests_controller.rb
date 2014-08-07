class GiftRequestsController < ApplicationController
  before_filter :authenticate_user!
  # autocomplete :gift_request, :title, :extra_data => [:description]
  autocomplete :tag, :name, :gift_request_count => [:description]
  # GET /gift_requests
  # GET /gift_requests.json

  def index
    @gift_request = GiftRequest.new
    if(params[:filter].nil?)
      @gift_requests = GiftRequest.order('gift_requests.created_at DESC').page(params[:page]).per(10)
    elsif params[:filter] == "popular"
      @gift_requests = GiftRequest.popular.page(params[:page]).per(10)
    elsif params[:filter] == "top"
      @gift_requests = GiftRequest.top.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gift_requests }
    end
  end

  # GET /gift_requests/1
  # GET /gift_requests/1.json
  def show
    @request = request.fullpath
    @gift_request = GiftRequest.find(params[:id])
    if @gift_request.user_has_access?(current_user.id) == false
      flash[:notice] = "You are not authorized to view the gift request"
      redirect_to '/gift_requests'
    else
      @gift_request_comments = @gift_request.comments
      @gift_request_likes = @gift_request.likes
      @gift_request_tags = @gift_request.tags
      respond_to do |format|
        UserView.create(gift_request_id: @gift_request.id, user_id: current_user.id)
        format.html # show.html.erb
        format.json { render json: @gift_request }
      end
    end
  end

  # GET /gift_requests/new
  # GET /gift_requests/new.json
  def new
    @gift_request = GiftRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gift_request }
    end
  end

  # GET /gift_requests/1/edit
  def edit
    @gift_request = GiftRequest.find(params[:id])
  end

#"gift_request"=>{"user_id"=>"1", "title"=>"test private post", "description"=>"asdasda", "public"=>"false", "black_list"=>"", "white_list"=>"2,-2"}, "tags"=>["test", "private post"],
  # POST /gift_requests
  # POST /gift_requests.json
  def create
    if (params[:gift_request]["public"] == "false")
      private_post = true
    else
      private_post = false
    end
    @gift_request = GiftRequest.new(user_id: current_user.id, title: params[:gift_request]["title"], description: params[:gift_request]["description"], private_post: private_post)    

    respond_to do |format|
      if @gift_request.save && @gift_request.attach_tags_to_gift_request(params[:tags])
        if @gift_request.private_post
          white_lists = params[:gift_request]["white_list"].split(',').map {|n| n.to_i}
          if white_lists.include?(0)
            white_list = GiftRequestWhiteList.new(gift_request_id: @gift_request.id, user_id: 0)
            white_list.save
          else
            all_follower = white_lists.include?(-1)
            all_following = white_lists.include?(-2)
            white_lists.each do |white_list|
              if white_list > 0
                if all_following && @gift_request.user.following?(User.find(white_list))
                  next
                elsif all_follower && @gift_request.user.followed?(User.find(white_list))
                  next
                else
                  white_list = GiftRequestWhiteList.new(gift_request_id: @gift_request.id, user_id: white_list)
                  white_list.save
                end
              else
                white_list = GiftRequestWhiteList.new(gift_request_id: @gift_request.id, user_id: white_list)
                white_list.save
              end
            end
          end

          black_lists = params[:gift_request]["black_list"].split(',').map {|n| n.to_i}
          black_lists.each do |black_list|
            black_list = GiftRequestBlackList.new(gift_request_id: @gift_request.id, user_id: black_list)
            black_list.save
          end

        end
          format.html { redirect_to @gift_request, notice: 'Gift request was successfully created.' }
          format.json { render json: @gift_request, status: :created, location: @gift_request }
      else
        format.html { redirect_to '/gift_requests/new', notice: @gift_request.errors.full_messages.to_sentence}
        format.json { render json: @gift_request.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gift_requests/1
  # PUT /gift_requests/1.json
  def update
    @gift_request = GiftRequest.find(params[:id])
  
    respond_to do |format|
      if @gift_request.update_attributes(params[:gift_request])
       format.html { redirect_to @gift_request, notice: 'Gift request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gift_request.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gift_requests/1
  # DELETE /gift_requests/1.json
  def destroy
    @gift_request = GiftRequest.find(params[:id])
    @gift_request.destroy

    respond_to do |format|
      format.html { redirect_to gift_requests_url }
      format.json { head :no_content }
    end
  end


  def gift_request_search
    total_gift_requests = GiftRequest.search params[:keyword]
    @gift_requests = []
    total_gift_requests.each do |gift_request|
      if gift_request.user_has_access?(current_user.id)
        @gift_requests << gift_request
      end
    end
    @keyword = params[:keyword]
    #redirect_to "/gift_requests/gift_request_search"
  end

end
