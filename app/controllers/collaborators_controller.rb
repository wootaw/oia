class CollaboratorsController < ApplicationController
  before_action :authenticate_user!

  def index
    existing_project do |project|
      @collaborators = project.collaborators.where.not(state: [:confirmed, :left]).order("created_at DESC")
    end
  end
end
