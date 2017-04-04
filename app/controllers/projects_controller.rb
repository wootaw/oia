class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_owner, only: [:show]
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
      @project = Project.first
      @project.created_at = Time.now
      # if @project.save
        render template: "projects/create.json.jbuilder"
      # else
      #   render json: { code: 1000, msgs: @project.errors.full_messages }
      # end
    else
      render json: { code: 403, msgs: 'Unknown type' }, status: 403
    end
  end

  def show
    if @owner.nil?
      render_404
    else
      set_project
      if @project.nil?
        render_404
      elsif can?(:read, @project)
        @change   = @project.lastest_change
        @document = if params[:slug].present?
          resource = @project.resources.find_by(slug: params[:slug])
          if resource.nil?
            @project.the_documents(@change).find_by(name: params[:slug])
          else
            resource.document
          end
        else
          @hide_top = true
          @project.the_documents(@change).take
        end
        
        if @document.nil?
          render_404
        else
          @resources = @document.the_resources(@change)
        end
      else
        render_404
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
