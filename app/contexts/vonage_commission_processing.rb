require_relative 'vonage_commission_processing/determine_sales'
require_relative 'vonage_commission_processing/determine_brackets'
require_relative 'vonage_commission_processing/generate_payouts'
require_relative 'vonage_commission_processing/managers'
require_relative 'vonage_commission_processing/revenue_sharing'
require_relative 'vonage_commission_processing/negative_balances'

class VonageCommissionProcessing
  include DetermineSales
  include DetermineBrackets
  include GeneratePayouts
  include Managers
  include RevenueSharing
  include NegativeBalances

  def process automated = false, paycheck = nil
    return if RunningProcess.running? self
    begin
      RunningProcess.running! self
      @count = 0
      @paycheck = paycheck || get_paycheck
      return unless @paycheck
      generate_payouts
      change_manager_payouts
      clear_existing_payouts
      save_payouts
      process_negative_balances
      ProcessLog.create process_class: "VonageCommissionProcessing", records_processed: @count if automated
      self
    ensure
      RunningProcess.shutdown! self
    end
  end

  private

  def clear_existing_payouts
    VonageSalePayout.where(vonage_paycheck: @paycheck).destroy_all
    self
  end

  def save_payouts
    return unless @all_payouts
    @all_payouts.compact!
    @all_payouts.each { |payout| @count += 1 if payout.save }
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