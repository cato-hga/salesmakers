require 'sale_importer'

class DaySalesCount < ActiveRecord::Base

  def self.validations_and_assocations
    validates :day, presence: true
    validates :saleable, presence: true
    validates :sales, presence: true

    belongs_to :saleable, polymorphic: true
  end

  def self.range_scopes
    range_scope
    period_scope
  end

  def self.range_scope
    scope :for_range, ->(range) {
      where('day >= ? AND day <= ?',
            range.first,
            range.last)
    }
  end

  def self.period_scope
    scope :for_period, ->(period, last = false) {
      for_range (Date.today.send("beginning_of_#{period}".to_sym) - (last ? 1.send(period.to_sym) : 0))..
                    (last ? Date.today.send("beginning_of_#{period}".to_sym) - 1.day : Date.today)
    }
  end

  def self.day_scopes
    scope :today, -> { where day: Date.today }
    scope :yesterday, -> { where day: Date.yesterday }
  end

  def self.week_scopes
    scope :this_week, -> { for_period 'week' }
    scope :last_week, -> { for_period 'week', true }
  end

  def self.month_scopes
    scope :this_month, -> { for_period 'month' }
    scope :last_month, -> { for_period 'month', true }
  end

  def self.year_scopes
    scope :this_year, -> { for_period 'year' }
  end

  validations_and_assocations
  range_scopes
  day_scopes
  week_scopes
  month_scopes
  year_scopes

  def self.import
    SaleImporter.new
  end

end
