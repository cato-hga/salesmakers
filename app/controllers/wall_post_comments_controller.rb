class WallPostCommentsController < ApplicationController
  layout false

  def create
    @wall_post_comment = WallPostComment.new wall_post_comment_params
    unless @wall_post_comment.save
      render partial: 'shared/errors', locals: { object: @wall_post_comment }, status: :bad_request
    end
  end

  def update
    @wall_post_comment = WallPostComment.find params[:id]
    if @wall_post_comment.update_attributes wall_post_comment_params
      flash[:notice] = 'Edits saved.'
    else
      flash[:error] = 'Your edit could NOT be savd!'
      redirect_to :back
    end
  end

  def destroy
  end

  private

  def wall_post_comment_params
    params.require(:wall_post_comment).permit :wall_post_id,
                                              :person_id,
                                              :comment
  end
end
