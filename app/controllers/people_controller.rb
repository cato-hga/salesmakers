require 'apis/gateway'
require 'apis/mojo'

class PeopleController < ProtectedController
  include HTTParty
  base_uri 'https://rbdconnect.com/ws/com.retailingwireless.core.onboarder'
  default_timeout 120

  after_action :verify_authorized, except: [
                                     :index,
                                     :search,
                                     :csv,
                                     :new_sms_message,
                                     :create_sms_message,
                                     :org_chart,
                                     :show,
                                     :sales,
                                     :commission,
                                     :update_changelog_entry_id
                                 ]
  after_action :verify_policy_scoped, except: [
                                        :index,
                                        :search,
                                        :csv,
                                        :new_sms_message,
                                        :create_sms_message,
                                        :org_chart,
                                        :show,
                                        :update_changelog_entry_id,
                                        :new,
                                        :create
                                    ]
  before_action :find_person, only: [:sales, :commission]
  before_action :setup_onboarding_fields, only: [:new, :create]

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
    @communication_log_entries = @person.communication_log_entries.page(params[:communication_log_entries_page]).per(10)
    @comcast_leads = ComcastLead.person(@person.id)
    @comcast_installations = ComcastSale.person(@person.id)
  end

  def new
    @candidate = params[:candidate_id] ? Candidate.find(params[:candidate_id]) : nil
    authorize Person.new
  end

  def create
    body = params
    authorize Person.new
    response = self.class.post '', {
                                     body: body,
                                     #headers: { 'Content-Type' => 'application/xml', 'Accept' => 'application/xml' },
                                     basic_auth: {
                                         username: 'aatkinson@retaildoneright.com',
                                         password: 'ct924dbr'
                                     }
                                 }
    hash = Hash.from_xml response.body if response.success?
    if not response.success? or hash['error']
      flash[:error] = hash && hash['error'] ? hash['error']['message'] : 'Unknown Error. Please contact support.'
      render :new
    else
      if link_candidate_to_person hash
        flash[:notice] = 'Person created successfully and candidate removed from pool!'
      else
        flash[:notice] = 'Person created successfully!'
      end
      redirect_to new_person_path
    end
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
    @available_paychecks = VonagePaycheck.available_paychecks
    @payouts = VonageSalePayout.where(vonage_paycheck: @paycheck).
        where(person: @person)
    @refunds = VonageRefund.where('refund_date >= ? AND refund_date <= ? AND person_id = ?',
                                  @paycheck.commission_start,
                                  @paycheck.commission_end,
                                  @person.id)
  end

  def update_changelog_entry_id
    person = Person.find params[:id]
    person.update changelog_entry_id: params[:changelog_entry_id]
    render nothing: true
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

  def setup_onboarding_fields
    @domains = [
        ['rbd-von.com', 'rbd-von.com'],
        ['rbd-spr.com', 'rbd-spr.com'],
        ['cc.salesmakersinc.com', 'cc.salesmakersinc.com'],
        ['srs.salesmakersinc.com', 'srs.salesmakersinc.com'],
        ['retaildoneright.com', 'retaildoneright.com']
    ]
    @areas = Area.where('connect_salesregion_id IS NOT NULL')
    @recruiters = Person.where(active: true)
    @candidate_sources = [
        ['Field Hire', 'Field Hire'],
        ['HQ Hire', 'HQ Hire']
    ]
    @referrers = Person.where('connect_user_id IS NOT NULL')
    @pay_rates = ConnectSalaryCategory.where(isactive: 'Y')
    @states = ["AK", "AL", "AR", "AS", "AZ", "CA", "CO",
               "CT", "DC", "DE", "FL", "GA", "GU", "HI",
               "IA", "ID", "IL", "IN", "KS", "KY", "LA",
               "MA", "MD", "ME", "MI", "MN", "MO", "MS",
               "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
               "NV", "NY", "OH", "OK", "OR", "PA", "PR",
               "RI", "SC", "SD", "TN", "TX", "UT", "VA",
               "VI", "VT", "WA", "WI", "WV", "WY"].map {
        |s| [s, s]
    }
    @params = params
  end

  def link_candidate_to_person(hash)
    return unless params[:candidate_id] && hash && hash['success']
    sleep 5
    @candidate = Candidate.find(params[:candidate_id]) || return
    @person = Person.find_by connect_user_id: hash['success'] || return
    @candidate.update person: @person
  end
end
