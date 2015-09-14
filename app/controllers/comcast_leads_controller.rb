require 'sales_leads_customers/sales_leads_customers_extension'

class ComcastLeadsController < ApplicationController
  include ComcastCSVExtension
  include SalesLeadsCustomersExtension

  before_action :set_comcast_customer, only: [:new, :create, :edit, :update, :reassign, :reassign_to, :dismiss, :destroy]
  before_action :do_authorization, only: [:new, :create]
  before_action :set_comcast_locations, only: [:edit, :update]
  after_action :verify_authorized, only: [:new, :create, :index, :reassign, :dismiss]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    shared_index('Comcast', 'Lead')
  end

  def new
    @comcast_lead = ComcastLead.new
  end

  def create
    Chronic.time_class = Time.zone
    @comcast_lead = ComcastLead.new comcast_lead_params
    @comcast_lead.comcast_customer = @comcast_customer
    lead_create('comcast', @comcast_lead, comcast_customers_path)
  end

  def edit
    @comcast_lead = ComcastLead.find params[:id]
    authorize @comcast_lead.comcast_customer
  end

  def update
    @comcast_lead = ComcastLead.find params[:id]
    @comcast_lead.update update_params
    @comcast_lead.follow_up_by = Chronic.parse params.require(:comcast_lead).permit(:follow_up_by)[:follow_up_by]
    if @comcast_lead.save
      @current_person.log? 'update',
                           @comcast_lead,
                           @current_person,
                           nil,
                           nil,
                           update_params[:comments]
      flash[:notice] = 'Lead updated successfully'
      redirect_to comcast_customers_path
    else
      flash[:error] = 'Lead could not be updated'
      render :edit
    end

  end

  def destroy
    @comcast_lead = ComcastLead.find params[:id]
    begin
      reason = ComcastLeadDismissalReason.find params[:comcast_customer][:comcast_lead_dismissal_reason_id]
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Comcast Lead Dismissal reason is required'
      redirect_to dismiss_comcast_customer_comcast_lead_path(@comcast_customer, @comcast_lead) and return
    end
    comment = params[:comcast_customer][:dismissal_comment]
    if @comcast_lead.update active: false and @comcast_customer.update comcast_lead_dismissal_reason_id: reason.id, dismissal_comment: comment
      flash[:notice] = 'Lead succesfully dismissed.'
      @current_person.log? 'destroy',
                           @comcast_lead,
                           @current_person,
                           nil,
                           nil
    else
      if !@comcast_lead || @comcast_lead.nil?
        flash[:error] = 'Could not dismiss lead.'
      elsif @comcast_lead && @comcast_lead.errors.any?
        flash[:error] = 'Could not dismiss lead: ' + @comcast_lead.errors.full_messages.join(', ') + @comcast_customers.errors.full_messsages.join(', ')
      else
        flash[:error] = 'Could not dismiss lead.'
      end
    end
    redirect_to comcast_customers_path
  end

  def reassign
    @comcast_lead = ComcastLead.find params[:id]
    @employees = @current_person.managed_team_members
    authorize @comcast_customer
  end

  def reassign_to
    authorize @comcast_customer
    new_person = Person.find params[:person_id]
    if @comcast_customer.update person: new_person
      @current_person.log? 'reassign_lead',
                           @comcast_customer,
                           new_person
      redirect_to comcast_customers_path
    end
  end

  def dismiss
    authorize @comcast_customer
    @comcast_lead = ComcastLead.find params[:id]
    @dismissal_reasons = ComcastLeadDismissalReason.where(active: true)
  end

  private

  def set_comcast_customer
    @comcast_customer = ComcastCustomer.find params[:comcast_customer_id]
  end

  def comcast_lead_params
    params.require(:comcast_lead).permit :tv,
                                         :internet,
                                         :phone,
                                         :security,
                                         :ok_to_call_and_text,
                                         :comments
  end

  def update_params
    params.require(:comcast_lead).permit :tv,
                                         :internet,
                                         :phone,
                                         :security,
                                         :ok_to_call_and_text,
                                         :comments,
                                         comcast_customer_attributes: [
                                             :first_name,
                                             :last_name,
                                             :location_id,
                                             :mobile_phone,
                                             :other_phone,
                                             :person_id,
                                             :id
                                         ]
  end

  def do_authorization
    authorize ComcastCustomer.new
  end
end