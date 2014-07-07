class LinesController < ApplicationController
  def index
    @search = Line.search(params[:q])
    @lines = @search.result.order('identifier').page(params[:page])
  end

  def show
    @line = Line.find params[:id]
  end

  def create
  end

  def new
  end

  def destroy
  end

  def edit
  end

  def update
  end
end
