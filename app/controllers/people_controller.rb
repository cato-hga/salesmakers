class PeopleController < ApplicationController
  require 'apis/mojo'

  def index
    @search = Person.search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

  def show
    @person = Person.find params[:id]
    @log_entries = LogEntry.where trackable_type: 'Person', trackable_id: @person.id
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @person.email, 12
    @assignee_tickets = mojo.assignee_open_tickets @person.email
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
