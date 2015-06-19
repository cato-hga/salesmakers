# == Schema Information
#
# Table name: c_bp_salcategory
#
#  c_bp_salcategory_id  :string(32)       not null, primary key
#  ad_client_id         :string(32)       not null
#  ad_org_id            :string(32)       not null
#  isactive             :string(1)        default("Y"), not null
#  created              :datetime         not null
#  createdby            :string(32)       not null
#  updated              :datetime         not null
#  updatedby            :string(32)       not null
#  c_bpartner_id        :string(32)       not null
#  c_salary_category_id :string(32)       not null
#  datefrom             :datetime         not null
#

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

  def datefrom
    self[:datefrom].remove_eastern_offset
  end
end
