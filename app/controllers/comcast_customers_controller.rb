class ComcastCustomersController < ApplicationController
  after_action :verify_authorized

  def new
    authorize ComcastCustomer.new
  end

  def create
  end
end
