require 'sales_leads_customers/sales_leads_customers_extension'

class DirecTVLeadsController < ApplicationController
  include DirecTVCSVExtension
  include SalesLeadsCustomersExtension

  before_action :set_directv_customer, only: [:new, :create, :edit, :update, :reassign, :reassign_to, :dismiss, :destroy]
  before_action :do_authorization, only: [:new, :create]
  after_action :verify_authorized, only: [:new, :create, :index, :reassign, :dismiss]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    shared_index('DirecTV', 'Lead')
  end

  def new
    @directv_lead = DirecTVLead.new
  end

  def create
    Chronic.time_class = Time.zone
    @directv_lead = DirecTVLead.new directv_lead_params
    @directv_lead.directv_customer = @directv_customer
    lead_create('directv', @directv_lead, directv_customers_path)
  end

  def edit
    @directv_lead = DirecTVLead.find params[:id]
    authorize @directv_lead.directv_customer
  end

  def update
    @directv_lead = DirecTVLead.find params[:id]
    lead_update('directv', @directv_lead, directv_customers_path)
  end

  def destroy
    @directv_lead = DirecTVLead.find params[:id]
    reason = DirecTVLeadDismissalReason.find params[:directv_customer][:directv_lead_dismissal_reason_id]
    comment = params[:directv_customer][:dismissal_comment]
    if @directv_lead.update active: false and @directv_customer.update directv_lead_dismissal_reason_id: reason.id, dismissal_comment: comment
      flash[:notice] = 'Lead succesfully dismissed.'
      @current_person.log? 'destroy',
                           @directv_lead,
                           @current_person,
                           nil,
                           nil
    else
      flash[:error] = 'Could not dismiss lead: ' + @directv_lead.errors.full_messages.join(', '), +@directv_customers.errors.full_messsages.join(', ')
    end
    redirect_to directv_customers_path
  end

  def reassign
    @directv_lead = DirecTVLead.find params[:id]
    @employees = @current_person.managed_team_members
    authorize @directv_customer
  end

  def reassign_to
    authorize @directv_customer
    new_person = Person.find params[:person_id]
    if @directv_customer.update person: new_person
      @current_person.log? 'reassign_lead',
                           @directv_customer,
                           new_person
      redirect_to directv_customers_path
    end
  end

  def dismiss
    authorize @directv_customer
    @directv_lead = DirecTVLead.find params[:id]
    @dismissal_reasons = DirecTVLeadDismissalReason.where(active: true)
  end

  private

  def set_directv_customer
    @directv_customer = DirecTVCustomer.find params[:directv_customer_id]
  end

  def directv_lead_params
    params.require(:directv_lead).permit :tv,
                                         :internet,
                                         :phone,
                                         :security,
                                         :ok_to_call_and_text,
                                         :comments
  end

  def update_params
    params.require(:directv_lead).permit :tv,
                                         :internet,
                                         :phone,
                                         :security,
                                         :ok_to_call_and_text,
                                         :comments
  end

  def do_authorization
    authorize DirecTVCustomer.new
  end
end