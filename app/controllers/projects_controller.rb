class ProjectsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource :project
  include ActionView::Helpers::DateHelper

  def index
    render json: { un: params[:login], pn: params[:project_name] }
  end

  def new
    @project = Project.new(clazz: :jpublic, owner: current_user)
    render layout: false
  end

  def create
    # sleep(3)
    @project = Project.new(project_params)

    if /\AUser|Team\Z/ === project_params[:owner_type] && can?(:create, @project)
      @project.assign_keys
      if @project.save
        render json: { 
          code: 201, 
          projects: {
            id:       @project.id,
            name:     @project.name,
            summary:  @project.summary,
            created:  distance_of_time_in_words_to_now(@project.created_at),
            version:  @project.version_number
          } 
        }
      else
        render json: { code: 1000, msgs: @project.errors.full_messages }
      end
    else
      render json: { code: 403, msgs: 'Unknown type' }, status: 403
    end
  end

  protected

  def project_params
    params.require(:project).permit(:name, :summary, :owner_type, :owner_id)
  end

end
