module PersonPositionModelExtension

  def department
    return nil unless self.position
    self.position.department
  end

  def hq?
    self.position and self.position.hq?
  end

  def field?
    self.position and self.position.field?
  end

  def clients
    self.person_areas.each.map(&:client)
  end

  def projects
    self.person_areas.each.map(&:project)
  end

  def manager_or_hq?
    return true if self.hq?
    manager = false
    self.person_areas.each { |pa| pa.manages? ? manager = true : next }
    manager
  end

end