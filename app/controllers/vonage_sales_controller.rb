class VonageSalesController < ApplicationController
  before_action :do_authorization, only: [:new, :create]
  after_action :verify_authorized

  def new
    @vonage_sale = VonageSale.new
  end

  def show

  end

  def create
    @vonage_sale = VonageSale.new(vonage_sale_params)
    if @vonage_sale.save
      redirect_to new_vonage_sale_path
    else
      render :new
    end
  end

  private

  def vonage_sale_params
    params.require(:vonage_sale).permit :person_id,
                                        :sale_date,
                                        :confirmation_number,
                                        :location_id,
                                        :customer_first_name,
                                        :customer_last_name,
                                        :mac,
                                        :vonage_product_id,
                                        :gift_card_number,
                                        :person_acknowledged
  end

  def do_authorization
    authorize VonageSale.new
  end

end