class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  authorize_resource :project
  include ActionView::Helpers::DateHelper

  # def index
  #   render json: { un: params[:login], pn: params[:project_name] }
  # end

  def new
    # sleep(3)
    @project = Project.new(clazz: :jpublic, owner: current_user)
    render layout: false
  end

  def create
    # sleep(1)
    @project = Project.new(project_params)

    if /\AUser|Team\Z/ === project_params[:owner_type] && can?(:create, @project)
      @project.assign_keys
      @project.collaborators.build(state: :joined, member: current_user)
      # @project = Project.take
      # @project.created_at = Time.now
      if @project.save
        render template: "projects/create.json.jbuilder"
      else
        render json: { code: 1000, msgs: @project.errors.full_messages }
      end
    else
      render json: { code: 403, msgs: 'Unknown type' }, status: 403
    end
  end

  def show
    existing_project do |project|
      @change   = project.lastest_change
      @document = if params[:slug].present?
        resource = project.resources.find_by(slug: params[:slug])
        if resource.nil?
          project.the_documents(@change).find_by(name: params[:slug])
        else
          resource.document
        end
      else
        project.the_documents(@change).take
      end
      
      if @document.nil?
        render_404
      else
        @resources = @document.the_resources(@change)
      end
    end
  end

  def templates
    render partial: params[:t]
  end

  protected

  def project_params
    params.require(:project).permit(:name, :summary, :owner_type, :owner_id, :clazz)
  end

end
