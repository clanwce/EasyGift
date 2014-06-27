class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]

	def index

	end

	def test

	end

	def userhome

	end

	def account_settings
	end

	def profile

	end
end
