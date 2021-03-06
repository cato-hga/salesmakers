# == Schema Information
#
# Table name: rsprint_timesheet
#
#  rsprint_timesheet_id   :string(32)       not null, primary key
#  createdby              :string(32)       not null
#  updatedby              :string(32)       not null
#  created                :datetime         not null
#  updated                :datetime         not null
#  isactive               :string(1)        default("Y"), not null
#  ad_client_id           :string(32)       not null
#  ad_org_id              :string(32)       not null
#  shift_date             :datetime         not null
#  employee_login         :string(255)
#  site_num               :string(255)      not null
#  site_name              :string(255)      not null
#  eid                    :string(255)      not null
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  hours                  :decimal(, )      not null
#  timesheet_row          :string(255)      not null
#  c_bpartner_location_id :string(32)
#  ad_user_id             :string(32)
#

require 'rails_helper'

describe ConnectBlueforceTimesheet do
  describe 'determination of Project' do
    let!(:star_project) { create :project, name: 'STAR' }
    let!(:sprint_prepaid_project) { create :project, name: 'Sprint Prepaid' }
    let!(:directv_retail_project) { create :project, name: 'DirecTV Retail' }
    let!(:comcast_retail_project) { create :project, name: 'Comcast Retail' }

    context 'for Sprint Prepaid' do
      let(:sprint_prepaid_timesheet) { ConnectBlueforceTimesheet.find '38EA3B7B4BB67B0A014BBCF1896C5F56' }

      it 'returns the correct project' do
        expect(sprint_prepaid_timesheet.project).to eq sprint_prepaid_project
      end
    end

    context 'for STAR' do
      let(:star_timesheet) { ConnectBlueforceTimesheet.find '38EA3B7B4ED4A077014EDDCC689C0273' }

      it 'returns the correct project' do
        expect(star_timesheet.project).to eq star_project
      end
    end

    context 'for DirecTV Retail' do
      let(:directv_retail_timesheet) { ConnectBlueforceTimesheet.find '38EA3B7B4E6DB688014ECD8BA10B2095' }

      it 'returns the correct project' do
        expect(directv_retail_timesheet.project).to eq directv_retail_project
      end
    end

    context 'for Comcast Retail' do
      let(:comcast_retail_timesheet) { ConnectBlueforceTimesheet.find '38EA3B7B4E6DB688014ECCBDB1D87294' }

      it 'returns the correct project' do
        expect(comcast_retail_timesheet.project).to eq comcast_retail_project
      end
    end
  end
end
