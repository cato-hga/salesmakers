# == Schema Information
#
# Table name: changelog_entries
#
#  id            :integer          not null, primary key
#  department_id :integer
#  project_id    :integer
#  all_hq        :boolean
#  all_field     :boolean
#  heading       :string           not null
#  description   :text             not null
#  released      :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe ChangelogEntry do
  subject { build :changelog_entry }

  describe 'visibility' do
    let(:department) { build_stubbed :department }
    let(:project) { build_stubbed :project }

    context 'with department chosen' do
      before { subject.department = department }

      it 'does not allow project' do
        subject.project = project
        expect(subject).not_to be_valid
      end

      it 'does not allow all_hq' do
        subject.all_hq = true
        expect(subject).not_to be_valid
      end

      it 'does not allow all_field' do
        subject.all_field = true
        expect(subject).not_to be_valid
      end
    end

    context 'with project chosen' do
      before { subject.project = project }

      it 'does not allow department' do
        subject.department = department
        expect(subject).not_to be_valid
      end

      it 'does not allow all_hq' do
        subject.all_hq = true
        expect(subject).not_to be_valid
      end

      it 'does not allow all_field' do
        subject.all_field = true
        expect(subject).not_to be_valid
      end
    end

    context 'with all_hq true' do
      before { subject.all_hq = true }

      it 'does not allow department' do
        subject.department = department
        expect(subject).not_to be_valid
      end

      it 'does not allow project' do
        subject.project = project
        expect(subject).not_to be_valid
      end
    end

    context 'with all_field true' do
      before { subject.all_field = true }

      it 'does not allow department' do
        subject.department = department
        expect(subject).not_to be_valid
      end

      it 'does not allow project' do
        subject.project = project
        expect(subject).not_to be_valid
      end
    end
  end

  describe 'visible scope' do
    let(:position) { create :position }
    let(:person) { create :person, position: position}
    let(:project) { create :project }
    let(:area) { create :area, project: project }
    let!(:outside_department) { create :department }
    let(:outside_project) { create :project }
    let!(:outside_area) { create :area, project: outside_project }
    let!(:person_area) { create :person_area, person: person, area: area }

    let!(:everything_entry) { create :changelog_entry }
    let!(:department_entry) { create :changelog_entry, department: position.department }
    let!(:outside_department_entry) { create :changelog_entry, department: outside_department }
    let!(:project_entry) { create :changelog_entry, project: project }
    let!(:outside_project_entry) { create :changelog_entry, project: outside_project }
    let!(:all_hq_entry) { create :changelog_entry, all_hq: true }
    let!(:all_field_entry) { create :changelog_entry, all_field: true }

    it 'is correct for an hq employee' do
      position.hq = true
      position.field = false
      entries = ChangelogEntry.visible(person)
      expect(entries.count).to eq(4)
    end

    it 'is correct for a field employee' do
      position.hq = false
      position.field = true
      entries = ChangelogEntry.visible(person)
      expect(entries.count).to eq(4)
    end

    it 'is correct for neither a field nor hq employee' do
      position.hq = false
      position.field = false
      entries = ChangelogEntry.visible(person)
      expect(entries.count).to eq(3)
    end
  end
end
