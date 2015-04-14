module PersonNameModelExtension

  def display_name
    unless self[:display_name] and self[:display_name].length > 0
      return ''
    end
    NameCase(self[:display_name])
  end

  def name
    self.display_name
  end

  def position_name
    if self.position
      self.position.name
    else
      nil
    end
  end

  def supervisor_name
    if self.supervisor
      self.supervisor.display_name
    else
      nil
    end
  end
end