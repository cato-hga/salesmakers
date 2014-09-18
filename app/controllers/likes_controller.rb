class LikesController < ApplicationController
  def create
    like = Like.new wall_post_id: params[:wall_post_id], person: @current_person
    if like.save
      render text: ''
    else
      render text: '', status: :bad_request
    end
  end

  def destroy
  end

end
