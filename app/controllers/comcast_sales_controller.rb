class ComcastSalesController < ApplicationController
  before_action :setup_comcast_customer, except: [:index, :csv]
  before_action :setup_time_slots, except: [:index, :csv]
  before_action :setup_former_providers, except: [:index, :csv]
  after_action :verify_policy_scoped, only: [:index, :csv]

  def index
    @search = policy_scope(ComcastSale).search(params[:q])
    @comcast_sales = @search.result.page(params[:page])
    authorize ComcastSale.new
  end

  def csv
    @search = policy_scope(ComcastSale).search(params[:q])
    @comcast_sales = @search.result
    respond_to do |format|
      format.html { redirect_to comcast_sales_path }
      format.csv do
        render csv: @comcast_sales,
               filename: "comcast_sales_#{date_time_string}",
               except: [
                   :id,
                   :comcast_customer_id,
                   :created_at
               ],
               add_methods: [
                   :comcast_customer_name,
                   :comcast_customer_mobile_phone,
                   :comcast_customer_other_phone
               ]
      end
    end
  end

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
      #Kicking back a flash message for incorrect dates
      if sale_time == nil
        @comcast_sale.errors.add :order_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
      end
      if install_time == nil
        @comcast_sale.errors.add :install_date, ' entered could not be used - there may be a typo or invalid date. Please re-enter'
      end
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