class HistoricalLocationSource
  def initialize
    @locations = Location.all
  end

  def each
    @locations.each do |location|
      att = location.attributes.merge({ date: Date.current })
      att.delete('id')
      att.delete('created_at')
      att.delete('updated_at')
      yield att
    end
  end
end