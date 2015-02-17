class ComcastLeadsController < ApplicationController
  before_action :set_comcast_customer, only: [:new, :create, :edit, :update]
  before_action :do_authorization, only: [:new, :create]

  def new
    @comcast_lead = ComcastLead.new
  end

  def create
    @comcast_lead = ComcastLead.new comcast_lead_params
    @comcast_lead.comcast_customer = @comcast_customer
    @comcast_lead.follow_up_by = Chronic.parse params.require(:comcast_lead).permit(:follow_up_by)[:follow_up_by]
    if @comcast_lead.save
      @current_person.log? 'create',
                           @comcast_lead,
                           @current_person,
                           nil,
                           nil,
                           comcast_lead_params[:comments]
      flash[:notice] = 'Lead saved successfully.'
      redirect_to comcast_customers_path
    else
      render :new
    end
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
      #flash[:error] = 'Could not dismiss lead.'
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