class UserSessionsController < Devise::SessionsController
  def new
    render layout: "landing_page"
  end
end