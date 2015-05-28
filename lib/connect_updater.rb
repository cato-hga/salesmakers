class ConnectUpdater

  def self.update(minutes)
    AreaUpdater.update
    Person.update_from_connect minutes
    PersonAddress.update_from_connect minutes
    Location.update_from_connect minutes
    Person.update_eids_from_connect
    Person.update_eids_from_connect_blueforce_usernames
    PersonPayRate.update_from_connect minutes
  end

  def self.update_shifts(duration)
    LegacyMinuteWorxTimesheetImporting.new(duration).import
    LegacyBlueforceTimesheetImporting.new(duration).import
  end

end