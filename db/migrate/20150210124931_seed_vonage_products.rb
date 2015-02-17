class SeedVonageProducts < ActiveRecord::Migration
  def self.up
    VonageProduct.create name: 'Vonage V-Portal',
                         price_range_maximum: 49.99
    VonageProduct.create name: 'Vonage Whole Home Kit',
                         price_range_minimum: 69.01
  end

  def self.down
    p = VonageProduct.find_by name: 'Vonage V-Portal'
    p.destroy if p
    p = VonageProduct.find_by name: 'Vonage Whole Home Kit'
    p.destroy if p
  end
end
