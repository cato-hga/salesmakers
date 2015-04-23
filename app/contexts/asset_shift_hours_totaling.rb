class AssetShiftHoursTotaling

  def initialize(duration)
    @duration = duration
  end

  def generate_totals
    shifts = Shift.where('date >= ?', DateTime.now - @duration)
    people = []
    for shift in shifts do
      people << shift.person unless shift.person.skip_for_assets?
    end
    for person in people do
      person_hours = Shift.where(person: person).sum(:hours).to_i
      if person_hours > 40
        person.update passed_asset_hours_requirement: true
      end
    end
    email_managers(people)
  end

  def email_managers(people)
    for person in people do
      supervisors = person.get_supervisors
      if supervisors == []
        AssetsMailer.no_supervisors_for_asset_approval_mailer.deliver_later
      else
        for supervisor in supervisors do
          AssetsMailer.asset_approval_mailer(supervisor).deliver_later
        end
      end
    end
  end

end