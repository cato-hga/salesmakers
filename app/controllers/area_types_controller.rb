class AreaTypesController < ApplicationController
  def index
    @area_types = AreaType.where project_id: params[:project_id]
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
