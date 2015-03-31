class VonageAccountStatusChangesImporter
  def initialize(file)
    @file = File.new(file)
    begin_processing
    self
  end

  def begin_processing
    set_spreadsheet
    return unless @spreadsheet
    process_row_hashes
    self
  end

  def process_row_hashes
    for row_hash in @spreadsheet.hashes do
      translate_and_store(row_hash)
    end
  end

  def set_spreadsheet
    roo_spreadsheet = Roo::Spreadsheet.open(@file.path)
    @spreadsheet = SimpleSpreadsheet.new(roo_spreadsheet)
    self
  end

  def translate_and_store(row_hash)
    vonage_account_status_change = translate(row_hash) || return
    vonage_account_status_change = never_been_sold_termination(vonage_account_status_change) || return
    vonage_account_status_change = remove_termination_fields(vonage_account_status_change) || return
    store(vonage_account_status_change)
  end

  def translate(row_hash)
    vonage_account_status_change = VonageAccountStatusChange.new
    row_hash.keys.each do |key|
      case key
        when "MAC ID"
          vonage_account_status_change.mac = row_hash[key]
        when "VDV - Account Status"
          vonage_account_status_change.status = status_from_initial(row_hash[key])
        when "VDV - Account Start Date"
          vonage_account_status_change.account_start_date = row_hash[key]
        when "VDV - Account End Date"
          vonage_account_status_change.account_end_date = row_hash[key]
        when "VDV - Termination Reason"
          vonage_account_status_change.termination_reason = row_hash[key]
      end
    end
    vonage_account_status_change
  end

  def status_from_initial(initial)
    case initial
      when "A"
        :active
      when "G"
        :grace
      when "S"
        :suspended
      when "T"
        :terminated
      else
        nil
    end
  end

  def remove_termination_fields(vonage_account_status_change)
    return vonage_account_status_change if vonage_account_status_change.terminated?
    vonage_account_status_change.account_end_date = nil
    vonage_account_status_change.termination_reason = nil
    vonage_account_status_change
  end

  def never_been_sold_termination(vonage_account_status_change)
    return vonage_account_status_change if vonage_account_status_change.status.present?
    vonage_account_status_change.status = :terminated
    vonage_account_status_change.account_start_date = Date.today
    vonage_account_status_change.account_end_date = Date.today
    vonage_account_status_change.termination_reason = 'Vonage reports as never having been activated.'
    vonage_account_status_change
  end

  def store(vonage_account_status_change)
    return if vonage_account_status_change.matches_latest?
    if vonage_account_status_change.save
      generate_refund(vonage_account_status_change)
      true
    else
      false
    end
  end

  def generate_refund(vonage_account_status_change)
    return unless refundable_termination?(vonage_account_status_change) or
    refundable_grace_or_suspend?(vonage_account_status_change)
    sale = find_sale(vonage_account_status_change.mac)
    return unless sale
    store_refund(vonage_account_status_change, sale)
  end

  def find_sale(mac)
    sales = VonageSale.where("mac ILIKE ?", mac).order(sale_date: :desc)
    return if sales.empty?
    sales.first
  end

  def refundable_termination?(vonage_account_status_change)
    return false unless vonage_account_status_change.account_end_date and
        vonage_account_status_change.account_start_date

    (vonage_account_status_change.terminated? or not
        vonage_account_status_change.status.present?) and
        vonage_account_status_change.account_end_date.mjd -
            vonage_account_status_change.account_start_date.mjd < 32
  end

  def refundable_grace_or_suspend?(vonage_account_status_change)
    sale = find_sale(vonage_account_status_change.mac)
    return false unless sale
    (vonage_account_status_change.grace? or
        vonage_account_status_change.suspended?) and
        Date.today.mjd - sale.sale_date.mjd < 36
  end

  def store_refund(vonage_account_status_change, sale)
    refund_date = vonage_account_status_change.account_end_date
    refund_date = refund_date ? refund_date + 1.week : Date.yesterday
    VonageRefund.create vonage_account_status_change: vonage_account_status_change,
                        person: sale.person,
                        refund_date: refund_date,
                        vonage_sale: sale
  end
end