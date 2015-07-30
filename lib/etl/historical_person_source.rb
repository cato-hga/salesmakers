class HistoricalPersonSource
  def initialize
    @people = Person.all.order(:created_at)
  end

  def each
    @people.each do |person|
      att = person.attributes
      att.delete('created_at')
      att.delete('updated_at')
      yield att
    end
  end
end