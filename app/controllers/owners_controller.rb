class OwnersController < ApplicationController
  before_action :set_owner

  def show
    @projects = if @owner.is_a?(User)
                  @owner.personal_projects.order("created_at DESC")
                end

    if can?(:create, Project.new(owner: @owner))
      # render template: "owners/show.json.jbuilder"
      
    else
      @projects = @projects.where(clazz: :jpublic)
    end

    respond_to do |format|
      format.html
      format.json { 
        sleep(3)
        render template: "owners/show.json.jbuilder" 
      }
    end

    
  end
end
