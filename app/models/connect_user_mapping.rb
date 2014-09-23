class ConnectUserMapping < ConnectModel
  self.table_name = :rc_umapping
  self.primary_key = :rc_umapping_id

  def self.employee_ids
    self.where data_source: 'EID'
  end

end
