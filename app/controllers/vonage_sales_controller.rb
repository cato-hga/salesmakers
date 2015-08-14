class VonageSalesController < ApplicationController
  before_action :do_authorization, only: [:new, :create]
  before_action :set_salesmaker, only: [:new, :create]
  before_action :set_vonage_locations, only: [:new, :create]
  before_action :chronic_time_zones
  after_action :verify_authorized

  def new
    @vonage_sale = VonageSale.new
    @vonage_products = VonageProduct.all
  end

  def create
    @vonage_products = VonageProduct.all
    @vonage_sale = VonageSale.new vonage_sale_params
    sale_date = params.require(:vonage_sale).permit(:sale_date)[:sale_date]
    chronic_time = Chronic.parse(sale_date)
    adjusted_time = chronic_time.present? ? chronic_time.in_time_zone : nil
    @vonage_sale.sale_date = adjusted_time
    if @vonage_sale.save
      flash[:notice] = 'Vonage Sale has been successfully created.'
      redirect_to new_vonage_sale_path
    else
      render :new
    end
  end

  private

  def set_salesmaker
    @salesmakers = @current_person.managed_team_members
    @salesmakers = [@current_person] if @salesmakers.empty?
  end

  def vonage_sale_params
    params.require(:vonage_sale).permit :person_id,
                                        :confirmation_number,
                                        :location_id,
                                        :customer_first_name,
                                        :customer_last_name,
                                        :mac,
                                        :mac_confirmation,
                                        :vonage_product_id,
                                        :gift_card_number,
                                        :gift_card_number_confirmation,
                                        :person_acknowledged
  end

  def do_authorization
    authorize VonageSale.new
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end

end