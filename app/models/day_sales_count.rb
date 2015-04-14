require 'sale_importer'

class DaySalesCount < ActiveRecord::Base
  validates :day, presence: true
  validates :saleable, presence: true
  validates :sales, presence: true

  belongs_to :saleable, polymorphic: true

  scope :for_range, ->(range) {
    where('day >= ? AND day <= ?',
          range.first,
          range.last)
  }

  def self.day_scopes
    scope :today, -> { where day: Date.today }
    scope :yesterday, -> { where day: Date.yesterday }
  end

  def self.week_scopes
    scope :this_week, -> {
      for_range Date.today.beginning_of_week..Date.today
    }
    scope :last_week, -> {
      for_range (Date.today.beginning_of_week - 1.week)..
                    (Date.today.beginning_of_week - 1.day)
    }
  end

  def self.month_scopes
    scope :this_month, -> {
      for_range Date.today.beginning_of_month..Date.today
    }
    scope :last_month, -> {
      for_range (Date.today.beginning_of_month - 1.month)..
                    (Date.today.beginning_of_month - 1.day)
    }
  end

  def self.year_scopes
    scope :this_year, -> {
      for_range Date.today.beginning_of_year..Date.today
    }
  end

  day_scopes
  week_scopes
  month_scopes
  year_scopes

  def self.import
    SaleImporter.new
  end

end
