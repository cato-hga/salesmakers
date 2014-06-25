class PeopleController < ApplicationController
  def index
    @search = Person.search(params[:q])
    @people = @search.result
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
