class PositionsController < ApplicationController
  def index
    @department = Department.find params[:department_id]
    @positions = Position.where department: @department
  end

  def new
    #TODO Authorize
  end

  def create
    #TODO Authorize
  end

  def show
    #TODO Authorize
  end

  def edit
    #TODO Authorize
  end

  def destroy
    #TODO Authorize
  end

  def update
    #TODO Authorize
  end
end
