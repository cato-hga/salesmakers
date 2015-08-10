module NegativeBalances

  private

  def process_negative_balances
    gather_person_list_for_balances
    self
  end

  def gather_person_list_for_balances
    return unless @people_with_sales
    @person_list_for_balances = @people_with_sales
    gather_people_with_refunds
    gather_people_with_balances
    @person_list_for_balances.uniq!
    make_negative_payout_hashes
    apply_negative_payout_hashes
  end

  def gather_people_with_refunds
    for refund in @paycheck.refunds do
      @person_list_for_balances << refund.person
    end
  end

  def gather_people_with_balances
    for balance in @paycheck.get_previous.vonage_paycheck_negative_balances do
      @person_list_for_balances << balance.person
    end
  end

  def make_negative_payout_hashes
    @negative_payout_hashes = []
    for person in @person_list_for_balances do
      payout_hash = {
          person: person,
          net_last_paycheck: @paycheck.get_previous.net_payout(person)
      }
      @negative_payout_hashes << payout_hash if payout_hash[:net_last_paycheck] < 0
    end
  end

  def apply_negative_payout_hashes
    return unless @negative_payout_hashes
    clear_existing_negative_balances
    for negative_hash in @negative_payout_hashes do
      create_negative_balance(negative_hash)
    end
  end

  def clear_existing_negative_balances
    @paycheck.vonage_paycheck_negative_balances.destroy_all
  end

  def create_negative_balance(negative_hash)
    balance = VonagePaycheckNegativeBalance.create vonage_paycheck: @paycheck,
                                                   balance: negative_hash[:net_last_paycheck],
                                                   person: negative_hash[:person]
    self
  end
end