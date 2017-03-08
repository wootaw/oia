class UsersController < ApplicationController

  def show
    @home_user = User.find_by(username: params[:login])
  end

  def exists
    case params[:type]
    when "username"
      result = A::RESERVED_WORDS.include?(params[:value])
      result = User.exists?(username: params[:value]) || Team.exists?(name: params[:value]) unless result
      render json: { exists: result }
    when "email"
      result = User.exists?(email: params[:value])
      render json: { exists: result }
    else
      render json: { code: 404, msg: 'Unknown type' }, status: 404
    end
  end
end
