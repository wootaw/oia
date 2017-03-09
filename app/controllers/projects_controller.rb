class ProjectsController < ApplicationController

  def index
    render json: { un: params[:login], pn: params[:project_name] }
  end

  def new
    render layout: false
  end
end
