class ConnectUpdater

  def self.update minutes, automated = false
    begin
      RunningProcess.running! self
      AreaUpdater.update automated
      Person.update_from_connect minutes, automated
      PersonAddress.update_from_connect minutes, automated
      Location.update_from_connect minutes, automated
      Person.update_eids_from_connect automated
      Person.update_eids_from_connect_blueforce_usernames automated
      PersonPayRate.update_from_connect minutes, automated
    ensure
      RunningProcess.shutdown! self
    end
  end

  def self.update_shifts duration, automated = false
    LegacyMinuteWorxTimesheetImporting.new(duration).import(automated)
    LegacyBlueforceTimesheetImporting.new(duration).import(automated)
    VonageComp07012015Processing.new.execute
  end

end