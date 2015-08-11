require 'rails_helper'

describe ConnectBlueforceTimesheet do
  describe 'determination of Project' do
    let!(:sprint_postpaid_project) { create :project, name: 'Sprint Postpaid' }
    let!(:sprint_retail_project) { create :project, name: 'Sprint Retail' }
    let!(:directv_retail_project) { create :project, name: 'DirecTV Retail' }
    let!(:comcast_retail_project) { create :project, name: 'Comcast Retail' }

    context 'for Sprint Retail' do
      let(:sprint_retail_timesheet) { ConnectBlueforceTimesheet.find '38EA3B7B4BB67B0A014BBCF1896C5F56' }

      it 'returns the correct project' do
        expect(sprint_retail_timesheet.project).to eq sprint_retail_project
      end
    end

    context 'for Sprint Postpaid' do
      let(:sprint_postpaid_timesheet) { ConnectBlueforceTimesheet.find '38EA3B7B4ED4A077014EDDCC689C0273' }

      it 'returns the correct project' do
        expect(sprint_postpaid_timesheet.project).to eq sprint_postpaid_project
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