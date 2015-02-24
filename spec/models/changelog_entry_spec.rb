require 'rails_helper'

describe ChangelogEntry do
  subject { build :changelog_entry }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a heading' do
    subject.heading = nil
    expect(subject).not_to be_valid
  end

  it 'requires a heading at least 5 characters in length' do
    subject.heading = '1234'
    expect(subject).not_to be_valid
  end

  it 'requires a description' do
    subject.description = nil
    expect(subject).not_to be_valid
  end

  it 'requires a description at least 20 characters long' do
    subject.description = 'a' * 19
    expect(subject).not_to be_valid
  end

  it 'requires a released datetime' do
    subject.released = nil
    expect(subject).not_to be_valid
  end

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
end