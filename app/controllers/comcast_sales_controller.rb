require 'sales_leads_customers/sales_leads_customers_extension'

class ComcastSalesController < ApplicationController
  include ComcastCSVExtension
  include SalesLeadsCustomersExtension

  before_action :setup_comcast_customer, except: [:index, :csv]
  before_action :setup_time_slots, except: [:index, :csv]
  before_action :setup_former_providers, except: [:index, :csv]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    shared_index('Comcast', 'Sale')
  end

  def new
    @comcast_sale = ComcastSale.new
    @comcast_sale.comcast_install_appointment = ComcastInstallAppointment.new
  end

  def create
    @comcast_sale = ComcastSale.new comcast_sale_params
    parse_times('comcast')
    create_sale
    if @comcast_sale.save
      log 'create'
      flash[:notice] = 'Sale saved successfully.'
      redirect_to comcast_customers_path and return
    else
      #Kicking back a flash message for incorrect dates
      incorrect_dates
      render :new and return
    end
  end

  private

  def create_sale
    @comcast_sale.order_date = @sale_time.to_date if @sale_time
    @comcast_sale.comcast_install_appointment.install_date = @install_time.to_date if @install_time
    @comcast_sale.comcast_customer = @comcast_customer
    @comcast_sale.person = @current_person
  end

  def incorrect_dates
    if @sale_time == nil
      @comcast_sale.errors.add :order_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
    end
    if @install_time == nil
      @comcast_sale.errors.add :install_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
    end
  end

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
                                         :comcast_lead_id,
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