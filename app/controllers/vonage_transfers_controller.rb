class VonageTransfersController < ApplicationController
  before_action :do_authorization
  after_action :verify_authorized

  def new
    @vonage_transfer = VonageTransfer.new
  end

  private

  def do_authorization
    authorize VonageDevice.new
  end
end
