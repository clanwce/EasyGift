class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]

	def index
		render layout: "landing_page"
	end

	def test

	end

	def feed
	
	
	#@feed = current_user.feed
	@feed = Kaminari.paginate_array(current_user.feed).page(params[:page]).per(10)
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
