class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :store_current_location, unless: :devise_controller?
  layout :layout

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email, :password, :remember_me])
  end

  private

  def layout
    false if devise_controller?
  end

  # def store_current_location
  #   store_location_for(:user, request.url)
  # end

  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end
end
