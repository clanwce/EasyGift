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

  private
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def edit_password
  end
end