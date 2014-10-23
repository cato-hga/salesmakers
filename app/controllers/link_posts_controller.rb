class LinkPostsController < ApplicationController
  layout false

  def create
    @link_post = LinkPost.new link_post_params
    @link_post.person = @current_person
    wall_id = params.require(:link_post).permit(:wall_id).first[1] if params.require(:link_post).permit(:wall_id).first
    @link_post.url = linkify @link_post.url
    if @link_post.save
      @wall_post = @link_post.create_wall_post Wall.find(wall_id), @current_person
      render :show
    else
      @object = @link_post
      render partial: 'shared/ajax_errors', status: :unprocessable_entity
    end
  end

  def show
    @link_post = LinkPost.find params[:id]
  end

  private

  # If the protocol is not http or https, replace the protocol with http.
  # If the link has no protocol specified, add http
  def linkify(link)
    new_link = link
    slash_slash_index = new_link.index('//')
    if slash_slash_index and not (new_link.starts_with?('http://') or
        new_link.starts_with?('https://'))
      new_link_length = new_link.length

      new_link = new_link[(slash_slash_index + 2)..new_link_length]
      return 'http://' + new_link
    end
    new_link = 'http://' + new_link unless slash_slash_index
    new_link
  end

  def link_post_params
    params.require(:link_post).permit(:url)
  end
end
