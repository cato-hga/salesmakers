require 'vonage_commission_processing/determine_sales'
require 'vonage_commission_processing/determine_brackets'
require 'vonage_commission_processing/generate_payouts'
require 'vonage_commission_processing/managers'
require 'vonage_commission_processing/revenue_sharing'
require 'vonage_commission_processing/negative_balances'

class VonageCommissionProcessing
  include DetermineSales
  include DetermineBrackets
  include GeneratePayouts
  include Managers
  include RevenueSharing
  include NegativeBalances

  def process(paycheck = nil)
    @paycheck = paycheck || get_paycheck
    return unless @paycheck
    generate_payouts
    change_manager_payouts
    clear_existing_payouts
    save_payouts
    process_negative_balances
    self
  end

  private

  def clear_existing_payouts
    VonageSalePayout.where(vonage_paycheck: @paycheck).destroy_all
    self
  end

  def save_payouts
    return unless @all_payouts
    @all_payouts.compact!
    @all_payouts.each { |payout| payout.save }
    self
  end

  module PaycheckDetermination
    def get_paycheck
      paychecks = VonagePaycheck.where('cutoff > ?', DateTime.now).
          order(:cutoff)
      return if paychecks.empty?
      paychecks.first
    end
  end

  include PaycheckDetermination
end