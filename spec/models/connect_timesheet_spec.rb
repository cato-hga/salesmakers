# == Schema Information
#
# Table name: rc_timesheet
#
#  rc_timesheet_id        :string(32)       not null, primary key
#  createdby              :string(32)       not null
#  updatedby              :string(32)       not null
#  isactive               :string(1)        default("Y"), not null
#  ad_client_id           :string(32)       not null
#  ad_org_id              :string(32)       not null
#  shift_date             :datetime         not null
#  hours                  :decimal(, )      not null
#  ad_user_id             :string(32)       not null
#  created                :datetime         not null
#  updated                :datetime         not null
#  c_bpartner_location_id :string(32)
#  time_docked            :decimal(, )      default(0.0), not null
#  overtime               :decimal(, )      default(0.0), not null
#  rate_of_pay            :string(255)
#  customer               :string(255)
#  punch_ins              :string(255)
#  punch_outs             :string(255)
#  break_starts           :string(255)
#  break_ends             :string(255)
#

require 'rails_helper'

describe ConnectTimesheet do
  describe 'determination of Project' do
    let!(:vonage_retail_project) { create :project, name: 'Vonage Retail' }
    let!(:vonage_events_project) { create :project, name: 'Vonage Events' }

    context 'for Vonage Events', pending: 'Side effect of events/retail "merge"' do
      let(:vonage_events_timesheet) { ConnectTimesheet.find '38EA3B7B4CC2E3CB014CC33DDDF64284' }

      it 'returns the correct project' do
        expect(vonage_events_timesheet.project).to eq vonage_events_project
      end
    end

    context 'for Vonage Retail' do
      let(:vonage_retail_timesheet) { ConnectTimesheet.find '38EA3B7B4AE89C48014AF41DDA85734F' }

      it 'returns the correct project' do
        expect(vonage_retail_timesheet.project).to eq vonage_retail_project
      end
    end
  end
end
