class TextPostsController < ApplicationController
  layout 'wall_post'

  def create
    @text_post = TextPost.new text_post_params
    @text_post.person = @current_person
    if @text_post.save
      @wall_post = @text_post.create_wall_post Wall.find(params[:wall_id]), @current_person
      render :show
    else
      @object = @text_post
      render partial: 'shared/ajax_errors', status: :unprocessable_entity
    end
  end

  private

  def text_post_params
    params.require(:text_post).permit(:content)
  end
end
