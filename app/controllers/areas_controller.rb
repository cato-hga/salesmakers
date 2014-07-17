class AreasController < ApplicationController
  def index
    @project = Project.find params[:project_id]
    all_areas = Area.where(project: @project).arrange(order: :name)
    if all_areas and not all_areas.empty?
      @areas = all_areas.first.first.siblings.where project: @project
    else
      []
    end
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
