require 'apis/gateway'

class PeopleController < ProtectedController
  after_action :verify_authorized, except: [:index, :search, :csv, :new_sms_message, :create_sms_message, :org_chart, :about, :show, :sales]
  after_action :verify_policy_scoped, except: [:index, :search, :csv, :new_sms_message, :create_sms_message, :org_chart, :about, :show]
  require 'apis/mojo'

  def index
    @search = Person.search(params[:q])
    @people = @search.result.order('display_name').page(params[:page])
  end

  def csv
    @search = Person.search(params[:q])
    @people = @search.result.order('display_name')
    respond_to do |format|
      format.html { redirect_to people_path }
      format.csv do
        render csv: @people,
               filename: "people_#{date_time_string}",
               except: [
                   :id,
                   :position_id,
                   :connect_user_id,
                   :supervisor_id,
                   :groupme_access_token,
                   :groupme_token_updated,
                   :group_me_user_id
               ],
               add_methods: [
                   :position_name,
                   :supervisor_name
               ]
      end
    end
  end

  def org_chart
    @departments = Department.joins(:positions).where('positions.hq = true').uniq
  end

  def show
    @person = Person.find params[:id]
    redirect_to about_person_path(@person) unless show_wall?(@person)
    @wall = @person.wall
    @walls = Wall.where id: @person.wall.id
    show_own = @person == @current_person
    @wall_posts = @wall.wall_posts
  end

  def sales
    @person = policy_scope(Person).find params[:id]
    set_show_wall
    unless @person
      flash[:error] = 'You do not have permission to view sales for that person.'
      redirect_to :back
    end
  end

  def about
    @person = Person.find params[:id]
    set_show_wall
    @log_entries = LogEntry.for_person(@person)
    @current_devices = @person.devices
    # mojo = Mojo.new
    # email = @person.email
    # @creator_tickets = mojo.creator_all_tickets email, 12
    # @assignee_tickets = mojo.assignee_open_tickets email
    @profile = @person.profile
    @profile_experiences = @profile.profile_experiences
    @profile_educations = @profile.profile_educations
    @communication_log_entries = @person.communication_log_entries
  end

  def new_sms_message
    @person = Person.find params[:id]
  end

  def create_sms_message
    person = Person.find params[:id]
    message = sms_message_params[:contact_message]
    gateway = Gateway.new
    gateway.send_text_to_person person, message, @current_person
    flash[:notice] = 'Message successfully sent.'
    redirect_to about_person_path(person)
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
      @person.profile.update image_params
    end
    if @person.update person_params
      flash[:notice] = 'Profile saved.'
      redirect_to edit_profile_path(@person.profile)
    else
      render 'profiles/edit'
    end
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

  def sms_message_params
    params.permit :contact_message
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

  def set_show_wall
    if show_wall? @person
      @show_wall = true
    else
      false
    end
  end
end
