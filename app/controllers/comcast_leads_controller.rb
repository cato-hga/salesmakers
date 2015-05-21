require 'sales_leads_customers/sales_leads_customers_extension'

class ComcastLeadsController < ApplicationController
  include ComcastCSVExtension
  include SalesLeadsCustomersExtension

  before_action :set_comcast_customer, only: [:new, :create, :edit, :update]
  before_action :do_authorization, only: [:new, :create]
  after_action :verify_authorized, only: [:new, :create, :index]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    @search = policy_scope(ComcastLead).search(params[:q])
    @comcast_leads = @search.result.page(params[:page])
    authorize ComcastLead.new
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
    if @comcast_lead.update active: false
      flash[:notice] = 'Lead succesfully dismissed.'
      @current_person.log? 'destroy',
                           @comcast_lead,
                           @current_person,
                           nil,
                           nil
    else
      flash[:error] = 'Could not dismiss lead: ' + @comcast_lead.errors.full_messages.join(', ')
    end
    redirect_to comcast_customers_path
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
                                         :comments
  end

  def do_authorization
    authorize ComcastCustomer.new
  end
end