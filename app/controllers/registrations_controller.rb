class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
  	flash[:notice] = "Please verify email and log back in"
    '/landing'
  end

  def after_inactive_sign_up_path_for(resource)
  	flash[:notice] = "Please verify email and log back in"
    '/landing'
  end
end