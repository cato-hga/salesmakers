# == Schema Information
#
# Table name: c_salary_category
#
#  c_salary_category_id :string(32)       not null, primary key
#  created              :datetime         not null
#  createdby            :string(32)       not null
#  updated              :datetime         not null
#  updatedby            :string(32)       not null
#  ad_client_id         :string(32)       not null
#  ad_org_id            :string(32)       not null
#  name                 :string(60)       not null
#  description          :string(255)
#  isactive             :string(1)        default("Y"), not null
#  iscostapplied        :string(1)        default("Y"), not null
#

class ConnectSalaryCategory < ConnectModel
  self.table_name = :c_salary_category
  self.primary_key = :c_salary_category_id

  has_many :connect_business_partner_salary_categories,
           primary_key: 'c_salary_category_id',
           foreign_key: 'c_salary_category_id'

  default_scope { order(:name) }
end
