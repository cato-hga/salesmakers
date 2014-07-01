class PeopleController < ApplicationController
  def index
    @search = Person.search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

  def show
    @person = Person.find params[:id]
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
