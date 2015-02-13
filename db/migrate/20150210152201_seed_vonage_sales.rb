class SeedVonageSales < ActiveRecord::Migration
  def self.up
    return unless Rails.env.production?
    puts "Importing sales from beginning of year. This could take a while..."
    importer = LegacyVonageSaleImporting.new(Time.now - Date.today.beginning_of_year.to_time)
    sales = importer.import
    puts "Imported #{sales.count} sales with #{importer.unmatched_sales.count} unmatched sales."
  end
end
