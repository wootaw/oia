class DocumentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_owner, only: [:show]

  def show
    # sleep(3)

    if @owner.nil?
      render_404
    else
      set_project
      if @project.nil?
        render_404
      elsif can?(:read, @project)
        changes = @project.version_changes
        if params[:version].present?
          @change = changes.find_by(position: params[:version])
        else
          @change = changes.order("changes.position DESC").take
        end
        
        if @change.nil?
          render_404
        else
          documents = @project.the_documents(@change)
          current_document = documents.find_by(name: params[:id])
          if current_document.nil?
            render_404
          else
            case params[:location]
            when 'current'
              @document = current_document
            when 'top'
              @document = documents.where("documents.position < ?", current_document.position).order("position DESC").take
            when 'bottom'
              @document = documents.where("documents.position > ?", current_document.position).order(:position).take
            else
              render_404
            end
          end
        end
      else
        render_404
      end
    end
  end

end
