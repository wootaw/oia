class UsersController < ApplicationController

  def show
    @home_user = User.find_by(username: params[:login])
  end

  def exists
    result = /\Ausername|email\Z/ === params[:type]
    result = User.exists?(params[:type] => params[:value]) if result
    render json: { exists: result }
  end
end
