class DirecTVEodsController < ApplicationController
  before_action :do_authorization
  before_action :set_directv_locations, only: [:new, :create]

  def new
    @directv_eod = DirecTVEod.new
  end

  def create
    @directv_eod = DirecTVEod.new directv_eod_params
    if @directv_eod.save
      flash[:notice] = 'End of Day report saved successfully'
      @current_person.log? 'create',
                           @directv_eod
      redirect_to directv_customers_path
    else
      puts @directv_eod.errors.full_messages
      flash[:error] = 'End of day report was NOT saved'
      render :new
    end
  end

  private

  def directv_eod_params
    params.require(:directv_eod).permit(:location_id,
                                        :person_id,
                                        :eod_date,
                                        :sales_pro_visit,
                                        :sales_pro_visit_takeaway,
                                        :directv_visit,
                                        :directv_visit_takeaway,
                                        :cloud_training,
                                        :cloud_training_takeaway

    )
  end

  def do_authorization
    authorize DirecTVCustomer.new
  end

end

