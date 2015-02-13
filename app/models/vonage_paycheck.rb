class VonagePaycheck < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :wages_start, presence: true, uniqueness: true
  validates :wages_end, presence: true, uniqueness: true
  validates :commission_start, presence: true, uniqueness: true
  validates :commission_end, presence: true, uniqueness: true
  validates :cutoff, presence: true
  validate :wages_end_after_start
  validate :commission_end_after_start
  validate :cutoff_after_wages_end
  validate :cutoff_after_commission_end
  validate :wages_start_unique_range
  validate :wages_end_unique_range
  validate :commission_start_unique_range
  validate :commission_end_unique_range

  has_many :vonage_sale_payouts

  private

  def wages_end_after_start
    return unless wages_end and wages_start
    if wages_end < wages_start
      errors.add(:wages_end, 'must be after the wages start date')
    end
  end

  def commission_end_after_start
    return unless commission_end and commission_start
    if commission_end < commission_start
      errors.add(:commission_end, 'must be after the commission start date')
    end
  end

  def cutoff_after_wages_end
    return unless cutoff and wages_end
    if cutoff < wages_end
      errors.add(:cutoff, 'must be after the wages end date')
    end
  end

  def cutoff_after_commission_end
    return unless cutoff and commission_end
    if cutoff < commission_end
      errors.add(:cutoff, 'must be after the commission end date')
    end
  end

  def wages_start_unique_range
    return unless wages_start
    existing_range = VonagePaycheck.where('wages_start <= ? AND wages_end >= ?',
                                          wages_start, wages_start)
    return if existing_range.empty?
    errors.add(:wages_start, "cannot be within another paycheck's wages range")
  end

  def wages_end_unique_range
    return unless wages_end
    existing_range = VonagePaycheck.where('wages_start <= ? AND wages_end >= ?',
                                          wages_end, wages_end)
    return if existing_range.empty?
    errors.add(:wages_end, "cannot be within another paycheck's wages range")
  end

  def commission_start_unique_range
    return unless commission_start
    existing_range = VonagePaycheck.where('commission_start <= ? AND commission_end >= ?',
                                          commission_start, commission_start)
    return if existing_range.empty?
    errors.add(:commission_start, "cannot be within another paycheck's wages range")
  end

  def commission_end_unique_range
    return unless commission_end
    existing_range = VonagePaycheck.where('commission_start <= ? AND commission_end >= ?',
                                          commission_end, commission_end)
    return if existing_range.empty?
    errors.add(:commission_end, "cannot be within another paycheck's wages range")
  end
end
