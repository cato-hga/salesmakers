class ComcastCustomersController < ApplicationController
  before_action :do_authorization
  before_action :set_locations, only: [:new, :create]
  after_action :verify_authorized


  def new
    authorize ComcastCustomer.new
    @comcast_customer = ComcastCustomer.new
  end

  def create
    @comcast_customer = ComcastCustomer.new customer_params
    @comcast_customer.person = @current_person
    if @comcast_customer.save
      @current_person.log? 'create', @comcast_customer, @current_person
      redirect_to new_comcast_customer_comcast_sale_path(@comcast_customer)
    else
      render :new
    end
  end

  private

  def customer_params
    params.require(:comcast_customer).permit :location_id,
                                             :first_name,
                                             :last_name,
                                             :mobile_phone,
                                             :other_phone,
                                             :person_id,
                                             :comments
  end

  def do_authorization
    authorize ComcastCustomer.new
  end

  def set_locations
    comcast = Project.find_by name: 'Comcast Retail'
    @locations = comcast.locations_for_person @current_person
  end
end
