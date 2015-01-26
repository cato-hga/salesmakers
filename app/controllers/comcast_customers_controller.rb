class ComcastCustomersController < ApplicationController
  before_action :do_authorization
  after_action :verify_authorized


  def new
    authorize ComcastCustomer.new
  end

  def create
    @comcast_customer = ComcastCustomer.new customer_params
    if @comcast_customer.save
      @current_person.log? 'create', @comcast_customer, @current_person
      #Redirection pending COMcastSales
    end
  end

  private

  def customer_params
    params.require(:comcast_customer).permit(:first_name, :last_name, :mobile_phone, :other_phone, :person_id, :comments)
  end

  def do_authorization
    authorize ComcastCustomer.new
  end
end
