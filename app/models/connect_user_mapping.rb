class ConnectUserMapping < ConnectModel
  self.table_name = :rc_umapping
  self.primary_key = :rc_umapping_id


  scope :blueforce_usernames, -> {
    where data_source: 'blueforceUsername'
  }
  scope :blueforce_passwords, -> {
    where data_source: 'blueforcePassword'
  }

  def self.employee_ids
    self.where data_source: 'EID'
  end
end
