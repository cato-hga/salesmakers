class ConnectBusinessPartnerSalaryCategory < ConnectModel
  self.table_name = :c_bp_salcategory
  self.primary_key = :c_bp_salcategory_id

  belongs_to :connect_business_partner,
             primary_key: 'c_bpartner_id',
             foreign_key: 'c_bpartner_id'
  belongs_to :connect_salary_category,
             primary_key: 'c_salary_category_id',
             foreign_key: 'c_salary_category_id'

  default_scope { order :datefrom }
end
