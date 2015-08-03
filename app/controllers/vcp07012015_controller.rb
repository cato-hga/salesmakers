class VCP07012015Controller < ApplicationController

  def show
    @vonage_commission_period07012015s = VonageCommissionPeriod07012015.where("hps_start < ?", Date.current).order(cutoff: :desc)
    @vonage_commission_period07012015 = params[:vonage_commission_period07012015_id] ?
        VonageCommissionPeriod07012015.find(params[:vonage_commission_period07012015_id]) :
        get_current_commission_period
    @person = policy_scope(Person).find params[:person_id]
    @vcp07012015_hps_shifts = @vonage_commission_period07012015.vcp07012015_hps_shifts.where(person: @person).joins(:shift).order("shifts.date ASC")
    @vcp07012015_hps_sales = @vonage_commission_period07012015.vcp07012015_hps_sales.where(person: @person).joins(:vonage_sale).order("vonage_sales.sale_date ASC, mac ASC")
    @vcp07012015_vested_sales_shifts = @vonage_commission_period07012015.vcp07012015_vested_sales_shifts.where(person: @person).joins(:shift).order("shifts.date ASC")
    @vcp07012015_vested_sales_sales = @vonage_commission_period07012015.vcp07012015_vested_sales_sales.where(person: @person).joins(:vonage_sale).order("vonage_sales.sale_date ASC, mac ASC")
    @total_hours = @person.shifts.sum(:hours)
  end

  private

  def get_current_commission_period
    periods = VonageCommissionPeriod07012015.where("cutoff > ?", DateTime.now).order(:cutoff)
    periods.empty? ? nil : periods.first
  end

end