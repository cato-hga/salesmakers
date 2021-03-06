class ApplicationMailer < ActionMailer::Base
  default from: "development@retaildoneright.com"
  layout 'mailer'
  add_template_helper ApplicationHelper

  protected

  def get_developer_emails
    get_position_emails 'developer'
  end

  def get_operations_emails
    get_position_emails 'operations coordinator'
  end

  def get_position_emails(position_name_contains)
    positions = Position.where("name ILIKE '%#{position_name_contains}%'")
    return if positions.empty?
    people = Person.where(position: positions, active: true)
    return if people.empty?
    people.map { |person| person.email }
  end

  protected

  def handle_send options
    Retryable.retryable(tries: 3, on: Postmark::TimeoutError) do
      begin
        mail options
      rescue Postmark::InvalidMessageError
        # Do nothing
      end
    end
  end
end