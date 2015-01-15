class ConnectUpdater

  def self.update(minutes)
    AreaUpdater.update
    Person.update_from_connect minutes
    PersonAddress.update_from_connect minutes
  end

end