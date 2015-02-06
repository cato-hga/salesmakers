class ComcastSalesController < ApplicationController
  before_action :setup_comcast_customer
  before_action :setup_time_slots
  before_action :setup_former_providers

  def new
    @comcast_sale = ComcastSale.new
    @comcast_sale.comcast_install_appointment = ComcastInstallAppointment.new
  end

  def create
    @comcast_sale = ComcastSale.new comcast_sale_params
    sale_time = Chronic.parse params.require(:comcast_sale).permit(:order_date)[:order_date]
    install_time = Chronic.parse params.require(:comcast_sale).
                                     require(:comcast_install_appointment_attributes).
                                     permit(:install_date)[:install_date]
    @comcast_sale.order_date = sale_time.to_date if sale_time
    @comcast_sale.comcast_install_appointment.install_date = install_time.to_date if install_time
    @comcast_sale.comcast_customer = @comcast_customer
    @comcast_sale.person = @current_person
    if @comcast_sale.save
      log 'create'
      flash[:notice] = 'Sale saved successfully.'
      redirect_to comcast_customers_path and return
    else
      render :new and return
    end
  end

  private

  def setup_former_providers
    @former_providers = ComcastFormerProvider.all
  end

  def setup_comcast_customer
    @comcast_customer = ComcastCustomer.find params[:comcast_customer_id]
  end

  def setup_time_slots
    @time_slots = ComcastInstallTimeSlot.where(active: true)
  end

  def comcast_sale_params
    params.require(:comcast_sale).permit :order_number,
                                         :comcast_former_provider_id,
                                         :tv,
                                         :internet,
                                         :phone,
                                         :security,
                                         :customer_acknowledged,
                                         comcast_install_appointment_attributes: [
                                             :comcast_install_time_slot_id
                                         ]
  end

  def log(action)
    @current_person.log? action,
                         @comcast_sale,
                         @current_person
  end

end