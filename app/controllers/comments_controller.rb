class CommentsController < ApplicationController

  def preview
    @body = params[:body]

    respond_to do |format|
      format.json
    end
  end
end
