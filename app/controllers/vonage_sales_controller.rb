class VonageSalesController < ApplicationController
  after_action :verify_authorized

  def new
    authorize VonageSale.new
    @vonage_sale = VonageSale.new
  end
end