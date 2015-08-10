# == Schema Information
#
# Table name: rc_umapping
#
#  rc_umapping_id :string(32)       not null, primary key
#  ad_client_id   :string(32)       not null
#  ad_org_id      :string(32)       not null
#  isactive       :string(1)        default("Y"), not null
#  created        :datetime         not null
#  createdby      :string(32)       not null
#  updated        :datetime         not null
#  updatedby      :string(32)       not null
#  ad_user_id     :string(32)       not null
#  data_source    :string(255)      not null
#  mapping        :string(255)      not null
#

class ConnectUserMapping < ConnectModel
  self.table_name = :rc_umapping
  self.primary_key = :rc_umapping_id


  scope :blueforce_usernames, -> {
    where "data_source = 'blueforceUsername' AND char_length(mapping) > 0"
  }
  scope :blueforce_passwords, -> {
    where "data_source = 'blueforcePassword' AND char_length(mapping) > 0"
  }

  def self.employee_ids
    self.where data_source: 'EID'
  end
end
