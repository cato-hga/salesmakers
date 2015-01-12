class TwilioController < ApplicationController
  include Webhookable
  include ActionView::Helpers::TextHelper

  after_action :set_header
  skip_before_action :verify_authenticity_token
  skip_before_action CASClient::Frameworks::Rails::Filter

  def incoming_voice
    calling_number = incoming_voice_params[:From]
    calling_number = calling_number.sub! '+1', ''
    person = lookup_person calling_number
    response = Twilio::TwiML::Response.new do |r|
      if person
        total_sales = person.sales_today
        r.Say 'Hello, ' + person.first_name + '.'
        r.Say 'You have ' + pluralize(person.sales_today.to_s, 'sale') + ' today.'
        for employee in person.employees.where(active: true) do
          next if employee.sales_today < 1
          r.Say employee.first_name + ' ' + employee.last_name + ' has ' +
              pluralize(employee.sales_today.to_s, 'sale') + ' today'
          total_sales += employee.sales_today
        end
        if person.employees.where(active: true).count > 0
          r.Say 'The total number of sales for you and your employees is ' +
              total_sales.to_s + '.'
        end
      else
        r.Say 'Hello.'
        r.Say 'Unfortunately we could not locate your records based on the current phone number.'
        r.Say 'Please update your phone number by contacting the helpdesk at support dot RBD connect dot com.'
      end
      r.Say 'Thank You. Goodbye.'
    end

    render_twiml response
  end

  private

  def incoming_voice_params
    params.permit :From
  end

  def lookup_person(number)
    people = Person.where mobile_phone: number
    people = Person.where office_phone: number unless people.count > 0
    people = Person.where home_phone: number unless people.count > 0
    if people.count < 1
      return nil
    else
      people.first
    end
  end

end