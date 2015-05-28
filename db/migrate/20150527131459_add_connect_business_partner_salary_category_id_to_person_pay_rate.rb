class AddConnectBusinessPartnerSalaryCategoryIdToPersonPayRate < ActiveRecord::Migration
  def change
    add_column :person_pay_rates, :connect_business_partner_salary_category_id, :string
  end
end
