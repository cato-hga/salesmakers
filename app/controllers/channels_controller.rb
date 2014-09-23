class ChannelsController < ApplicationController
  before_action :verify_authorized

  def index
    #@project = Project.find params[:project_id]
    #@channels = Channel.where project: @project
  end

  def create
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
