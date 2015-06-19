# == Schema Information
#
# Table name: employments
#
#  id         :integer          not null, primary key
#  person_id  :integer
#  start      :date
#  end        :date
#  end_reason :string
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Employment do
  let(:connect_user) { build_stubbed :connect_user }
  let(:person) { build_stubbed :person, connect_user: connect_user }
  let(:employment) { create :employment, person: person }
  let!(:connect_termination) {
    build_stubbed :connect_termination,
                  connect_user: connect_user,
                  last_day_worked: Date.yesterday
  }

  before do
    allow(connect_user).to receive(:connect_terminations).and_return([connect_termination])
  end

  it 'ends from a ConnectTermination' do
    expect {
      employment.end_from_connect
    }.to change(employment, :end).from(nil).to(Date.yesterday)
  end

end
