class DirecTVLeadsController < ApplicationController
  include DirecTVCSVExtension

  before_action :set_directv_customer, only: [:new, :create, :edit, :update]
  before_action :do_authorization, only: [:new, :create]
  after_action :verify_authorized, only: [:new, :create, :index]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    @search = policy_scope(DirecTVLead).search(params[:q])
    @directv_leads = @search.result.page(params[:page])
    authorize DirecTVLead.new
  end

  def new
    @directv_lead = DirecTVLead.new
  end

  def create
    Chronic.time_class = Time.zone
    @directv_lead = DirecTVLead.new directv_lead_params
    @directv_lead.directv_customer = @directv_customer

    #The following section handle invalid Chronic dates, since we allow purposefully blank Follow Up Dates
    follow_up_by = params.require(:directv_lead).permit(:follow_up_by)[:follow_up_by]
    chronic_parse_follow_up_by = Chronic.parse follow_up_by
    Chronic.time_class = Time
    if follow_up_by.present? and chronic_parse_follow_up_by == nil
      flash[:error] = 'The date entered could not be used - there may be a typo or invalid date. Please re-enter'
      render :new and return
    else
      @directv_lead.follow_up_by = chronic_parse_follow_up_by
    end

    if @directv_lead.save
      @current_person.log? 'create',
                           @directv_lead,
                           @current_person,
                           nil,
                           nil,
                           directv_lead_params[:comments]
      flash[:notice] = 'Lead saved successfully.'
      redirect_to directv_customers_path
    else
      render :new
    end
  end

  def edit
    @directv_lead = DirecTVLead.find params[:id]
    authorize @directv_lead.directv_customer
  end

  def update
    @directv_lead = DirecTVLead.find params[:id]
    @directv_lead.update update_params
    @directv_lead.follow_up_by = Chronic.parse params.require(:directv_lead).permit(:follow_up_by)[:follow_up_by]
    if @directv_lead.save
      @current_person.log? 'update',
                           @directv_lead,
                           @current_person,
                           nil,
                           nil,
                           update_params[:comments]
      flash[:notice] = 'Lead updated successfully'
      redirect_to directv_customers_path
    else
      flash[:error] = 'Lead could not be updated'
      render :edit
    end

  end

  def destroy
    @directv_lead = DirecTVLead.find params[:id]
    if @directv_lead.update active: false
      flash[:notice] = 'Lead succesfully dismissed.'
      @current_person.log? 'destroy',
                           @directv_lead,
                           @current_person,
                           nil,
                           nil
    else
      flash[:error] = 'Could not dismiss lead: ' + @directv_lead.errors.full_messages.join(', ')
    end
    redirect_to directv_customers_path
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