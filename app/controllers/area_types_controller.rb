class AreaTypesController < ApplicationController
  def index
    @project = Project.find params[:project_id]
    @area_types = AreaType.where project: @project
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
