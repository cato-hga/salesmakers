class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  def track_visit(options)
    super do |visit|
      visit.person = controller.current_user
    end
  end

  def track_event(name, properties, options)
    super do |event|
      event.person = controller.current_user
    end
  end
end
