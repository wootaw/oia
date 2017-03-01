class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout :layout

  private

  def layout
    false if devise_controller?
  end
end
