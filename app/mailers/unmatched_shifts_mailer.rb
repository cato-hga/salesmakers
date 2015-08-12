class UnmatchedShiftsMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def unmatched_shifts(unmatched_shifts)
    return if unmatched_shifts.empty?
    @unmatched_shifts = unmatched_shifts
    developer_emails = get_developer_emails || return
    handle_send to: developer_emails,
                subject: 'Unmatched Shifts on Import'
  end

  private

  def get_developer_emails
    positions = Position.where("name ILIKE '%developer%'")
    return if positions.empty?
    people = Person.where(position: positions)
    return if people.empty?
    people.map { |person| person.email }
  end
end