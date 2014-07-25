require 'apis/groupme'

class GalleryController < ApplicationController
  def index
    groupme = GroupMe.new
    @images = groupme.get_images 100, 50
  end
end
