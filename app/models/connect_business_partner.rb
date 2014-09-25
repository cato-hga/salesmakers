class ConnectBusinessPartner < ConnectModel
  self.table_name = :c_bpartner
  self.primary_key = :c_bpartner_id

  belongs_to :connect_user,
             primary_key: 'c_bpartner_id',
             foreign_key: 'c_bpartner_id'
  has_many :connect_business_partner_salary_categories,
           foreign_key: 'c_bpartner_id',
           primary_key: 'c_bpartner_id'
  has_one :connect_salary_category,
          primary_key: 'c_salary_category_id',
          foreign_key: 'c_salary_category_id'
end
