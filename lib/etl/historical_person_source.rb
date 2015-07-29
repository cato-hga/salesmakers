class HistoricalPersonSource
  def initialize
    @people = Person.all.order(:created_at)
  end

  def each
    @people.each do |person|
      att = person.attributes.merge({ date: Date.current })
      att.delete('id')
      att.delete('created_at')
      att.delete('updated_at')
      supervisor_id = nil
      supervisor = HistoricalPerson.find_by email: person.email, date: Date.current if person.supervisor_id
      supervisor_id = supervisor.id if supervisor
      att['supervisor_id'] = supervisor_id
      yield att
    end
  end
end