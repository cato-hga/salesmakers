class VCP07012015Controller < ApplicationController

  def show
    @vonage_commission_period07012015 = params[:vonage_commission_period07012015_id] ?
        VonageCommissionPeriod07012015.find(params[:vonage_commission_period07012015_id]) :
        get_current_commission_period
    @person = Person.find params[:person_id]
    @vcp07012015_hps_shifts = @vonage_commission_period07012015.vcp07012015_hps_shifts
    @vcp07012015_hps_sales = @vonage_commission_period07012015.vcp07012015_hps_sales
    @vcp07012015_vested_sales_shifts = @vonage_commission_period07012015.vcp07012015_vested_sales_shifts
    @vcp07012015_vested_sales_sales = @vonage_commission_period07012015.vcp07012015_vested_sales_sales
  end

  private

  def get_current_commission_period
    periods = VonageCommissionPeriod07012015.where("cutoff > ?", DateTime.now).order(:cutoff)
    periods.empty? ? nil : periods.first
  end

end