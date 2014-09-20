class WallPostCommentsController < ApplicationController
  layout false

  def create
    @wall_post_comment = WallPostComment.new wall_post_comment_params
    unless @wall_post_comment.save
      render partial: 'shared/errors', locals: { object: @wall_post_comment }, status: :bad_request
    end
  end

  def update
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
