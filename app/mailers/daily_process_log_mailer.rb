class DailyProcessLogMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def generate
    developer_emails = get_developer_emails || return
    @process_logs = ActiveRecord::Base.connection.execute %{
      select

      pl.process_class,
      pl.notes,
      case when min(processes.id) is not null then true else false end as has_run,
      sum(processes.records_processed) as records_processed

      from process_logs pl
      left outer join process_logs processes
        on processes.process_class = pl.process_class
        and (processes.notes = pl.notes or pl.notes is null)
        and processes.created_at >= current_timestamp - interval '24 hours'

      group by pl.process_class, pl.notes
      order by pl.process_class, pl.notes
    }
    mail to: developer_emails,
        subject: '24-Hour Process History'
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