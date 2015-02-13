class ComcastEodsController < ApplicationController
  before_action :do_authorization
  before_action :set_comcast_locations, only: [:new, :create]

  def new
    @comcast_eod = ComcastEod.new
  end

  def create
  end

  private

  def do_authorization
    authorize ComcastCustomer.new
  end

end

