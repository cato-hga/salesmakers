class PeopleController < ProtectedController
  require 'apis/mojo'

  def index
    authorize Person.new
    @search = policy_scope(Person).search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

  def show
    @person = Person.find params[:id]
    authorize @person
    @log_entries = LogEntry.where trackable_type: 'Person', trackable_id: @person.id
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @person.email, 12
    @assignee_tickets = mojo.assignee_open_tickets @person.email
  end

  def new
    #TODO Authorize
  end

  def create
    #TODO Authorize
  end
  def edit
    #TODO Authorize
  end

  def update
    #TODO Authorize
  end

  def destroy
    #TODO Authorize
  end

  def search
    index
    render :index
  end

end
