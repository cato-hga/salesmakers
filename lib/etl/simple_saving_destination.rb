class SimpleSavingDestination
  def write record
    record.date = Date.current
    record.save
  end

  def close; end
end