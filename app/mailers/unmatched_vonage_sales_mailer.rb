class UnmatchedVonageSalesMailer < ApplicationMailer
  default from: "development@retaildoneright.com"

  def unmatched_sales(unmatched_sales)
    return if unmatched_sales.empty?
    @unmatched_sales = unmatched_sales
    developer_emails = get_developer_emails || return
    mail to: developer_emails,
        subject: 'Unmatched Vonage Sales on Import'
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