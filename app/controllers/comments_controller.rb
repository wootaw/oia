class CommentsController < ApplicationController

  def create
    @resource = Resource.find(params[:resource_id])
    @comment = current_user.comments.build(body: params[:body], target: @resource)

    if @comment.save
      render template: "comments/create.json.jbuilder"
    else
      render json: { code: 1000, msgs: @comment.errors.full_messages }
    end
  end

  def preview
    @body = params[:body]

    respond_to do |format|
      format.json
    end
  end
end
