class VonageDevicesController < ApplicationController
  before_action :do_authorization
  def new
    @vonagedevice = VonageDevice.new

  end



  # def receive_inventory
  #
  # end

  private

  def do_authorization
    authorize VonageDevice.new
  end

end