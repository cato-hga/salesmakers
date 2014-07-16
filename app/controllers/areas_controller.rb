class AreasController < ApplicationController
  def index
    @project = Project.find params[:project_id]
    @areas = Area.where project: @project
  end

  def show
  end

  def new
  end

  def update
  end

  def destroy
  end

  def edit
  end

  def create
  end
end
