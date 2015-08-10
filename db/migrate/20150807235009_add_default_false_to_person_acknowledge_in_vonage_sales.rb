class AddDefaultFalseToPersonAcknowledgeInVonageSales < ActiveRecord::Migration
  def change
    change_column :vonage_sales, :person_acknowledged, :boolean, default: false
  end
end
