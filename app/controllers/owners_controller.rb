class OwnersController < ApplicationController
  before_action :set_owner

  def show
    @projects = if @owner.is_a?(User)
                  @owner.personal_projects.order("created_at DESC")
                end

    if can?(:create, Project.new(owner: @owner))
      
    else
      
    end
  end
end
