class VonageInventoryReceivingController < ApplicationController
  def enter_inventory
    @vonageir = VonageInventoryReceive.new
  end

  def receive_inventory

  end
end
