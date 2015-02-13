class ComcastEodsController < ApplicationController
  before_action :do_authorization
  before_action :set_comcast_locations, only: [:new, :create]

  def new
    @comcast_eod = ComcastEod.new
  end

  def create
    @comcast_eod = ComcastEod.new comcast_eod_params
    if @comcast_eod.save
      redirect_to comcast_customers_path
    end
  end

  private

  def comcast_eod_params
    params.require(:comcast_eod).permit(:location_id,
                                        :eod_date,
                                        :sales_pro_visit,
                                        :sales_pro_visit_takeaway,
                                        :comcast_visit,
                                        :comcast_visit_takeaway,
                                        :cloud_training,
                                        :cloud_training_takeaway

    )
  end

  def do_authorization
    authorize ComcastCustomer.new
  end

end

