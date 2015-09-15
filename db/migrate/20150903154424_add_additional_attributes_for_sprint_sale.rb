class AddAdditionalAttributesForSprintSale < ActiveRecord::Migration
  def self.up
    add_column :sprint_sales, :five_intl_connect, :boolean
    add_column :sprint_sales, :ten_intl_connect, :boolean
    add_column :sprint_sales, :insurance, :boolean
    add_column :sprint_sales, :virgin_data_share_add_on_amount, :float
    add_column :sprint_sales, :virgin_data_share_add_on_description, :text
  end

  def self.down
    remove_column :sprint_sales, :five_intl_connect, :boolean
    remove_column :sprint_sales, :ten_intl_connect, :boolean
    remove_column :sprint_sales, :insurance, :boolean
    remove_column :sprint_sales, :virgin_data_share_add_on_amount, :float
    remove_column :sprint_sales, :virgin_data_share_add_on_description, :text
  end
end
