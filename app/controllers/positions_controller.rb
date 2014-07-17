class PositionsController < ApplicationController
  def index
    @department = Department.find params[:department_id]
    @positions = Position.where department: @department
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def destroy
  end

  def update
  end
end
