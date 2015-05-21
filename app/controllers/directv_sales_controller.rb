require 'sales_leads_customers/sales_leads_customers_extension'

class DirecTVSalesController < ApplicationController
  include DirecTVCSVExtension
  include SalesLeadsCustomersExtension

  before_action :setup_directv_customer, except: [:index, :csv]
  before_action :setup_time_slots, except: [:index, :csv]
  before_action :setup_former_providers, except: [:index, :csv]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    shared_index('DirecTV', 'Sale')
  end

  def new
    @directv_sale = DirecTVSale.new
    @directv_sale.directv_install_appointment = DirecTVInstallAppointment.new
  end

  def create
    @directv_sale = DirecTVSale.new directv_sale_params
    sale_create('DirecTV', @directv_sale, @directv_customer, directv_customers_path)
  end

  private

  def setup_former_providers
    @former_providers = DirecTVFormerProvider.all
  end

  def setup_directv_customer
    @directv_customer = DirecTVCustomer.find params[:directv_customer_id]
  end

  def setup_time_slots
    @time_slots = DirecTVInstallTimeSlot.where(active: true)
  end

  def directv_sale_params
    params.require(:directv_sale).permit :order_number,
                                         :directv_former_provider_id,
                                         :customer_acknowledged,
                                         :directv_lead_id,
                                         directv_install_appointment_attributes: [
                                             :directv_install_time_slot_id
                                         ]
  end

  def log(action)
    @current_person.log? action,
                         @directv_sale,
                         @current_person
  end
end