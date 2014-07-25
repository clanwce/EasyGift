class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]

	def index
		render layout: "landing_page"
	end

	def test

	end

	def feed
	
	
	@feed = current_user.feed
	
    # @gift_request = GiftRequest.new
    # if(params[:filter].nil?)
    #   @gift_requests = GiftRequest.order('gift_requests.created_at DESC').page(params[:page]).per(10)
    # elsif params[:filter] == "popular"
    #   @gift_requests = GiftRequest.popular.page(params[:page]).per(10)
    # elsif params[:filter] == "top"
    #   @gift_requests = GiftRequest.top.page(params[:page]).per(10)
    # end
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: @gift_requests }
	    end
	end

	def account_settings

	end

	def profile

	end

	def privacy_policy

	end

end
