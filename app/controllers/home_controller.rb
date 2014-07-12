class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]

	def index
		render layout: "landing_page"
	end

	def test

	end

	def userhome

	end

	def account_settings

	end

	def profile

	end

	def privacy_policy

	end

end
