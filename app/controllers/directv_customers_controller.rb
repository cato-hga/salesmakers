class DirecTVCustomersController < ApplicationController
  before_action :do_authorization, except: [:show]
  before_action :set_directv_locations, only: [:new, :create]
  after_action :verify_authorized

  def index
    @directv_leads = DirecTVLead.person(@current_person.id)
    @directv_installations = DirecTVSale.person(@current_person.id)
  end

  def show
    @directv_customer = DirecTVCustomer.find params[:id]
    @time_slots = DirecTVInstallTimeSlot.where(active: true)
    @directv_sale = DirecTVSale.new
    @directv_sale.directv_install_appointment = DirecTVInstallAppointment.new
    @former_providers = DirecTVFormerProvider.all
    @directv_customer_note = DirecTVCustomerNote.new
    authorize @directv_customer
  end

  def new
    authorize DirecTVCustomer.new
    @directv_customer = DirecTVCustomer.new
  end

  def create
    @directv_customer = DirecTVCustomer.new customer_params
    @directv_customer.person = @current_person
    if @directv_customer.save
      @current_person.log? 'create', @directv_customer, @current_person
      path = params.permit(:save_as_lead)[:save_as_lead] == 'true' ?
          new_directv_customer_directv_lead_path(@directv_customer) :
          new_directv_customer_directv_sale_path(@directv_customer)
      redirect_to path
      flash[:notice] = 'Customer saved'
    else
      render :new
    end
  end

  private

  def customer_params
    params.require(:directv_customer).permit :location_id,
                                             :first_name,
                                             :last_name,
                                             :mobile_phone,
                                             :other_phone,
                                             :person_id,
                                             :comments
  end

  def do_authorization
    authorize DirecTVCustomer.new
  end

end
