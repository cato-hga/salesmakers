class ComcastLeadsController < ApplicationController
  before_action :set_comcast_customer, only: [:new, :create]

  def new
    @comcast_lead = ComcastLead.new
  end

  def create
    @comcast_lead = ComcastLead.new comcast_lead_params
    @comcast_lead.comcast_customer = @comcast_customer
    @comcast_lead.follow_up_by = Chronic.parse params[:follow_up_by]
    if @comcast_lead.save
      @current_person.log? 'create',
                         @comcast_lead,
                         @current_person,
                         nil,
                         nil,
                         comcast_lead_params[:comments]
      flash[:notice] = 'Lead saved successfully.'
      redirect_to new_comcast_customer_path
    else
      render :new
    end
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
end