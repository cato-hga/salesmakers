require 'sales_leads_customers/sales_leads_customers_extension'

class ComcastSalesController < ApplicationController
  include ComcastCSVExtension
  include SalesLeadsCustomersExtension

  before_action :setup_comcast_customer, except: [:index, :csv]
  before_action :setup_time_slots, except: [:index, :csv]
  before_action :setup_former_providers, except: [:index, :csv]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    shared_index('Comcast', 'Sale', 'install_date DESC')
  end

  def new
    @comcast_sale = ComcastSale.new
    @comcast_sale.comcast_install_appointment = ComcastInstallAppointment.new
  end

  def create
    @comcast_sale = ComcastSale.new comcast_sale_params
    sale_create('Comcast', @comcast_sale, @comcast_customer, comcast_customers_path)
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