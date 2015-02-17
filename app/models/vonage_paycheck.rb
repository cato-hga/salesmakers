class VonagePaycheck < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :wages_start, presence: true, uniqueness: true
  validates :wages_end, presence: true, uniqueness: true
  validates :commission_start, presence: true, uniqueness: true
  validates :commission_end, presence: true, uniqueness: true
  validates :cutoff, presence: true
  validate :one_date_after_the_other
  validate :unique_ranges

  has_many :vonage_sale_payouts
  has_many :vonage_paycheck_negative_balances

  private

  def one_after_the_other(one, other)
    return unless self[one] and self[other]
    other_attribute_name = self.class.human_attribute_name(other)
    if self[one] < self[other]
      errors.add(one, "must be after #{other_attribute_name}")
    end
  end

  def one_date_after_the_other
    one_after_the_other(:wages_end, :wages_start)
    one_after_the_other(:commission_end, :commission_start)
    one_after_the_other(:cutoff, :wages_end)
    one_after_the_other(:cutoff, :commission_end)
  end

  def attr_outside_another_range(attr, start_attr, end_attr)
    return unless self[attr]
    end_attr_readable = self.class.human_attribute_name(end_attr).split
    end_attr_readable = end_attr_readable.first(end_attr_readable.size - 1).join(' ')
    existing_range = VonagePaycheck.where("#{start_attr.to_s} <= ? AND #{end_attr.to_s} >= ?",
                                          self[attr], self[attr])
    existing_range = existing_range.where('id != ?', self.id) if self.id
    return if existing_range.empty?
    errors.add(start_attr, "cannot be within another paycheck's #{end_attr_readable} range")
  end

  def unique_ranges
    attr_outside_another_range(:wages_start, :wages_start, :wages_end)
    attr_outside_another_range(:wages_end, :wages_start, :wages_end)
    attr_outside_another_range(:commission_start, :commission_start, :commission_end)
    attr_outside_another_range(:commission_end, :commission_start, :commission_end)
  end
end
