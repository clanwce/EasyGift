class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]

	def index

	end

	def test

	end

	def profile

	end

	def userhome

	end
end
