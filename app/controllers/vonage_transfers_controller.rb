class VonageTransfersController < ApplicationController

  def new
    @vonage_transfer = VonageTransfer.new
  end
end
