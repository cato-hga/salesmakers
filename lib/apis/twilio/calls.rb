module Twilio
  module Calls
    def handle_call(calling_number)
      calling_number = unformat_number calling_number
      person = lookup_object_by_number Person, calling_number
      Twilio::TwiML::Response.new do |r|
        if person
          announce_sales r, person
        else
          no_records_found r
        end
        r.Say 'Thank You. Goodbye.'
      end
    end

    def call_with_message(number, text)
      formatted_number = format_number number
      encoded_text = URI::encode text
      url = @message_twimlet_base
      url = url + 'Message%5B0%5D='
      url = url + encoded_text
      url = url + '&'
      @client.account.calls.create to: formatted_number,
                                   from: @from,
                                   url: url,
                                   'IfMachine' => 'hangup'
    end

    private

    def announce_sales(r, person)
      total_sales = person.sales_today
      r.Say 'Hello, ' + person.first_name + '.'
      r.Say 'You have ' + pluralize(person.sales_today.to_s, 'sale') + ' today.'
      managed_team_members = person.managed_team_members
      managed_team_members = managed_team_members.empty? ? [] : Person.where("id IN (#{managed_team_members.map(&:id)}) AND active = true")
      for employee in managed_team_members do
        next if employee.sales_today < 1
        r.Say employee.first_name + ' ' + employee.last_name + ' has ' +
                  pluralize(employee.sales_today.to_s, 'sale') + ' today'
        total_sales += employee.sales_today
      end
      unless managed_team_members.empty?
        r.Say 'The total number of sales for you and your employees is ' +
                  total_sales.to_s + '.'
      end
    end

    def no_records_found(r)
      r.Say 'Hello.'
      r.Say 'Unfortunately we could not locate your records based on the current phone number.'
      r.Say 'Please update your phone number by contacting the helpdesk at support dot RBD connect dot com.'
    end
  end
end