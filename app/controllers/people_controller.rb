class PeopleController < ProtectedController
  before_action :verify_authorized #TODO: Double check this
  after_action :verify_authorized, except: [:index, :about, :show]
  after_action :verify_policy_scoped, except: [:about, :show]
  require 'apis/mojo'

  def index
    authorize Person.new
    @search = policy_scope(Person).search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

  def show
    @person = Person.find params[:id]
    redirect_to about_person_path(@person) unless show_wall?(@person)
    @wall = @person.wall
    @walls = Wall.where id: @person.wall.id
    @wall_posts = @wall.wall_posts
  end

  def about
    @person = Person.find params[:id]
    if show_wall? @person
      @show_wall = true
    else
      false
    end
    @log_entries = LogEntry.where trackable_type: 'Person', trackable_id: @person.id
    mojo = Mojo.new
    @creator_tickets = mojo.creator_all_tickets @person.email, 12
    @assignee_tickets = mojo.assignee_open_tickets @person.email
    @profile = @person.profile
    @profile_experiences = @profile.profile_experiences
    @profile_educations = @profile.profile_educations
  end

  def new
  end

  def create
  end
  def edit
  end

  def update
    @person = policy_scope(Person).find params[:id]
    @profile = @person.profile
    if @person == @current_person
      authorize @person, :update_own_basic?
    else
      authorize @person
    end
    if image_params
      @person.profile.update_attributes image_params
    end
    if @person.update_attributes person_params
      flash[:notice] = 'Profile saved.'
      redirect_to @person
    else
      render 'profiles/edit'
    end
  end

  def destroy
  end

  def search
    index
    render :index
  end

  private

  def person_params
    if @person == @current_person
      params.require(:person).permit :personal_email, :mobile_phone, :home_phone, :office_phone
    end
  end

  def image_params
    params.require(:person).permit :image
  end

  def show_wall?(person)
    if person == @current_person.supervisor or not policy_scope(Person).include?(person)
      false
    else
      true
    end
  end
end
