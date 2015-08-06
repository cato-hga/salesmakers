class VonageInventoryReceivingsController < ApplicationController
  def enter_inventory
    @vonageir = VonageInventoryReceiving.new(vonage_inventory_receiving_params)

  end

  def receive_inventory

  end
end
