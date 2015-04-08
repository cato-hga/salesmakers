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
