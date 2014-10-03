require 'sale_importer'

class DaySalesCount < ActiveRecord::Base
  validates :day, presence: true
  validates :saleable, presence: true
  validates :sales, presence: true

  belongs_to :saleable, polymorphic: true

  scope :today, -> { where day: Date.today }
  scope :yesterday, -> { where day: Date.yesterday }
  scope :this_week, -> {
    where('day >= ? AND day <= ?',
          Date.today.beginning_of_week,
          Date.today)
  }
  scope :last_week, -> {
    where('day >= ? AND day <= ?',
          Date.today.beginning_of_week - 1.week,
          Date.today.beginning_of_week - 1.day)
  }
  scope :this_month, -> {
    where('day >= ? AND day <= ?',
          Date.today.beginning_of_month,
          Date.today)
  }
  scope :last_month, -> {
    where('day >= ? AND day <= ?',
          Date.today.beginning_of_month - 1.month,
          Date.today.beginning_of_month - 1.day)
  }
  scope :this_year, -> {
    where('day >= ? AND day <= ?',
          Date.today.beginning_of_year,
          Date.today)
  }

  scope :for_range, ->(range) {
    where('day >= ? AND day <= ?',
          range.first,
          range.last)
  }

  def self.import
    SaleImporter.new
  end

end
