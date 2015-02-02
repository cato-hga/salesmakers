require 'rails_helper'

describe ComcastCustomersHelper do
  let(:comcast_customer) { build_stubbed :comcast_customer }

  it 'displays a link to a customer' do
    output = helper.comcast_customer_link(comcast_customer)
    expect(output).to have_selector('a', text: comcast_customer.name)
  end

end