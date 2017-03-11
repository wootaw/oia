class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout

  def current_ability
    set_owner
    @current_ability ||= Ability.new(current_user, @owner)
  end

  def set_owner
    if params[:owner_name].present? && !@owner.present?
      @owner = User.find_by(username: params[:owner_name])
      @owner = Team.find_by(name: params[:owner_name]) if @owner.nil?
    end
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email, :password, :remember_me])
  end

  private

  def layout
    false if devise_controller?
  end

  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end
end
