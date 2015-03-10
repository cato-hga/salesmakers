class ConnectSalaryCategory < ConnectModel
  self.table_name = :c_salary_category
  self.primary_key = :c_salary_category_id

  has_many :connect_business_partner_salary_categories,
           primary_key: 'c_salary_category_id',
           foreign_key: 'c_salary_category_id'

  default_scope { order(:name) }
end
