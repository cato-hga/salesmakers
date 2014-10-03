require 'sale_importer'

class DaySalesCount < ActiveRecord::Base
  validates :day, presence: true
  validates :saleable, presence: true
  validates :sales, presence: true

  belongs_to :saleable, polymorphic: true

  def self.import
    SaleImporter.new
  end
end
