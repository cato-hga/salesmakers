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
    parse_times('directv')
    create_sale
    if @directv_sale.save
      log 'create'
      flash[:notice] = 'Sale saved successfully.'
      redirect_to directv_customers_path and return
    else
      #Kicking back a flash message for incorrect dates
      incorrect_dates
      render :new and return
    end
  end

  private

  def create_sale
    @directv_sale.order_date = @sale_time.to_date if @sale_time
    @directv_sale.directv_install_appointment.install_date = @install_time.to_date if @install_time
    @directv_sale.directv_customer = @directv_customer
    @directv_sale.person = @current_person
  end

  def incorrect_dates
    if @sale_time == nil
      @directv_sale.errors.add :order_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
    end
    if @install_time == nil
      @directv_sale.errors.add :install_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
    end
  end

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