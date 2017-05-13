class InvitationsController < ApplicationController

  def show
    @invitation = Invitation.find_by(key: params[:id])
  end
end
