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
                                        :masquerade,
                                        :update_changelog_entry_id,
                                        :new,
                                        :create,
                                        :send_asset_form
                                    ]
  before_action :find_person, only: [:sales, :commission, :send_asset_form]
  before_action :setup_onboarding_fields, only: [:new, :create]

  def index
    @search = Person.search(params[:q])
    @people = filter_results(@search.result).
        page(params[:page]).
        includes(:areas).
        includes(:most_recent_employment)
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
    @departments = Hash.new
    HeadquartersOrgChartEntry.all.each do |entry|
      if @departments.has_key?(entry.department_name)
        @departments[entry.department_name] << entry
      else
        @departments[entry.department_name] = [entry]
      end
    end
    @non_manager_person_areas = ActiveRecord::Base.connection.execute("
                                                                        select

                                                                        a.id as area_id,
                                                                        p.id,
                                                                        p.display_name

                                                                        from areas a
                                                                        left outer join person_areas pa
                                                                          on pa.area_id = a.id
                                                                        left outer join people p
                                                                          on p.id = pa.person_id

                                                                        where
                                                                          pa.manages = false
                                                                          and p.active = true

                                                                        order by area_id, p.display_name").
        group_by { |e| e['area_id'] }
  end

  def show
    @person = Person.find params[:id]
    @log_entries = @person.related_log_entries.page(params[:log_entries_page]).per(10)
    @asset_form_options = asset_form_options
    set_communication_variables
    set_comcast_variables
    set_shift_variables
  end

  def masquerade
    @person = Person.find params[:id]
    authorize Person.new
    session[:masquerade_as_email] = @person.email
    redirect_to root_path
  end

  def new
    @candidate = params[:candidate_id] ? Candidate.find(params[:candidate_id]) : nil
    authorize Person.new
  end

  def create
    authorize Person.new
    response = onboard(params)
    hash = Hash.from_xml response.body if response.success?
    if not response.success? or hash['error']
      flash[:error] = get_error_message(hash)
      render :new
    else
      flash[:notice] = get_success_message(hash)
      redirect_to new_person_path
    end
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

  def edit_position
    @positions = Position.all.order :name
    @person = policy_scope(Person).find params[:id]
    authorize @person
  end

  def update_position
    @positions = Position.all.order :name
    @person = policy_scope(Person).find params[:id]
    authorize @person
    unless params[:position_id]
      flash[:error] = 'You must select a position'
      redirect_to edit_position_person_path(@person)
    end
    old_position = @person.position
    new_position = Position.find params[:position_id]
    if @person.update position: new_position, update_position_from_connect: false
      @current_person.log? 'update_position',
                           @person,
                           new_position,
                           nil,
                           nil,
                           "from #{old_position.name} to #{new_position.name}"
      flash[:notice] = 'Position saved successfully.'
      redirect_to person_path(@person)
    else
      render :edit_position
    end
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

  def send_asset_form
    authorize Person.new
    template_guid, subject, role_name = *split_guid_and_subject
    if template_guid.nil?
      flash[:error] = 'You must select a form before clicking "Send Form".'
      redirect_to person_path(@person) and return
    end
    envelope_response = DocusignTemplate.send_ad_hoc_template template_guid, subject, set_signers_for_asset_form(role_name)
    handle_asset_form_envelope_response envelope_response, subject
    redirect_to person_path(@person)
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

  def set_communication_variables
    @communication_log_entries = @person.communication_log_entries.page(params[:communication_log_entries_page]).per(10)
    @candidate_contacts = @person.candidate_contacts
  end

  def set_comcast_variables
    @comcast_leads = ComcastLead.person(@person.id)
    @comcast_installations = ComcastSale.person(@person.id)
  end

  def set_shift_variables
    @shifts = Shift.where(person: @person).includes(:project)
    @shift_projects = []
    for shift in @shifts do
      @shift_projects << shift.project if shift.project and not @shift_projects.include? shift.project
    end
    for project in @shift_projects
      instance_variable_set "@#{project.name.squish.downcase.tr(" ", "_")}_hours", @shifts.where(person: @person, project_id: project.id).sum(:hours).round(2)
    end
  end

  def set_signers_for_asset_form role_name
    [
        {
            name: @person.display_name,
            email: @person.email,
            role_name: role_name
        }
    ]
  end

  def handle_asset_form_envelope_response envelope_response, subject
    if envelope_response
      flash[:notice] = 'Asset form sent successully.'
      @current_person.log? 'send_asset_form',
                           @person,
                           nil,
                           nil,
                           nil,
                           subject
    else
      flash[:error] = 'Could not send asset form. Please report this error to the development team.'
    end
  end

  def split_guid_and_subject
    template_guid_and_subject = params.permit(:template_guid_and_subject)[:template_guid_and_subject]
    return [nil, nil, nil] if template_guid_and_subject.blank? or not template_guid_and_subject.include?('|')
    [
        template_guid_and_subject.split('|')[0],
        template_guid_and_subject.split('|')[1] + @person.display_name,
        template_guid_and_subject.split('|')[2]
    ]
  end

  def link_candidate_to_person(hash)
    return unless params[:candidate_id] && hash && hash['success']
    sleep 5
    @candidate = Candidate.find(params[:candidate_id]) || return
    @person = Person.find_by connect_user_id: hash['success'] || return
    @candidate.update person: @person
  end

  def onboard(parameters)
    response = nil
    begin
      tries ||= 3
      response = self.class.post '', {
                                       body: parameters,
                                       basic_auth: {
                                           username: 'retailingw@retaildoneright.com',
                                           password: 'rbdC0nn3c7'
                                       }
                                   }
      response
    rescue Net::ReadTimeout => e
      tries -= 1
      if tries > 0
        retry
      else
        logger.info "Net Read timed out 3 times!"
      end
    end
    response
  end

  def get_error_message(hash)
    hash && hash['error'] ? hash['error']['message'] : 'Unknown Error. Please contact support.'
  end

  def get_success_message(hash)
    if link_candidate_to_person hash
      'Person created successfully and candidate removed from pool!'
    else
      'Person created successfully!'
    end
  end

  def asset_form_options
    [
        ['Emergency Tablet Deployment Agreement', 'B94E7297-A122-4172-A45D-B36534812B91|Emergency Tablet Deployment Agreement for: |Manager'],
        ['Laptop Agreement Form (Deduction Signed First)', '9E900BAE-CEBD-416C-BB64-491B3073CA5B|Laptop Agreement form for: |Employee'],
        ['Mobile Device Agreement Form for Management', '61B80AC4-0915-45A2-8C4E-DD809C58F953|Mobile Device Agreement Form for HQ Employee: |Employee'],
        ['Sprint Custom Phone Agreement', 'D978BD2B-2F16-45B5-92CE-CB0820E7674D|Sprint Custom Handset Agreement for: |Employee'],
        ['Tablet Exchange Form', '160E396D-71CB-4359-A201-FEF6566FDBC4|Tablet Exchange Form for: |Employee'],
        ['Tablet Exchange Form (Amnesty)', 'F3068461-1889-4C8E-B8E1-83DB64E6B594|Tablet Exchange Form for: |Employee'],
        ['Tablet Exchange Form (Lost/Stolen Tablet)', 'D490579D-D2B7-4AF6-804C-C3B692A5B43F|Tablet Exchange Form for: |Employee'],
    ]
  end
end
