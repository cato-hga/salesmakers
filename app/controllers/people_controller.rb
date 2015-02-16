require 'apis/gateway'

class PeopleController < ProtectedController
  after_action :verify_authorized, except: [:index, :search, :csv, :new_sms_message, :create_sms_message, :org_chart, :about, :show, :sales, :commission]
  after_action :verify_policy_scoped, except: [:index, :search, :csv, :new_sms_message, :create_sms_message, :org_chart, :about, :show]
  before_action :find_person, only: [:sales, :commission]
  require 'apis/mojo'

  def index
    @search = Person.search(params[:q])
    @people = filter_results(@search.result).page(params[:page])
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
    @log_entries = @person.related_log_entries.page(params[:log_entries_page]).per(10)
    @comcast_leads = ComcastLead.person(@person.id)
    @comcast_installations = ComcastSale.person(@person.id)
  end

  def sales

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
    redirect_to person_path(person)
  end

  def update

  end

  def search
    index
    render :index
  end

  def commission
    set_paycheck
    @payouts = VonageSalePayout.where(vonage_paycheck: @paycheck).
        where(person: @person)
    @refunds = VonageRefund.where('refund_date >= ? AND refund_date <= ? AND person_id = ?',
                                  @paycheck.commission_start,
                                  @paycheck.commission_end,
                                  @person.id)
  end

  private

  def person_params
    if @person == @current_person
      params.require(:person).permit :personal_email, :mobile_phone, :home_phone, :office_phone
    end
  end

  def find_person
    @person = policy_scope(Person).find params[:id]
    unless @person
      flash[:error] = "You do not have permission to view this person's details."
      redirect_to :back
    end
  end

  def set_paycheck
    if params[:paycheck_id]
      @paycheck = VonagePaycheck.find params[:paycheck_id]
    else
      @paycheck = VonagePaycheck.where('cutoff > ?', DateTime.now - 5.days).
          order(:cutoff).first
    end
  end

  def sms_message_params
    params.permit :contact_message
  end

  def image_params
    params.require(:person).permit :image
  end

  def filter_results(results)
    return results.where(active: true) unless @current_person.hq?
    results
  end
end
