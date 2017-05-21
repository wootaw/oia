class OwnersController < ApplicationController
  before_action :set_owner

  def show
    @projects = @owner.view_projects(current_user).order("created_at DESC")

    respond_to do |format|
      format.html
      format.json { 
        render template: "owners/show.json.jbuilder" 
      }
    end
    
  end
end
