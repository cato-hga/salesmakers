class HistoricalAreaSource
  def initialize
    @areas = Area.all
  end

  def each
    @areas.each do |area|
      att = area.attributes.merge({ date: Date.current })
      att.delete('id')
      att.delete('created_at')
      att.delete('updated_at')
      yield att
    end
  end
end