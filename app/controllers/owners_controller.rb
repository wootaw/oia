class OwnersController < ApplicationController
  before_action :set_owner

  def show
    @projects = if @owner.is_a?(User)
                  @owner.personal_projects.order("created_at DESC")
                end

    respond_to do |format|
      format.html
      format.json { render template: "owners/show.json.jbuilder" }
    end

    # if can?(:create, Project.new(owner: @owner))
    #   render template: "owners/show.json.jbuilder"
    # else

    # end
  end
end
