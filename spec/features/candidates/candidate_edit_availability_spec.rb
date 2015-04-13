require 'rails_helper'

describe 'Editing Candidates Availabilty' do

  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.create key: 'candidate_index',
                                             description: 'Blah blah blah',
                                             permission_group: permission_group }
  let!(:candidate) { create :candidate, candidate_availability: available }
  let(:available) { create :candidate_availability, sunday_first: true }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit edit_candidate_candidate_availability_path(candidate, available)
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit candidate_path candidate
      within('.widget.availability') do
        click_on 'Edit'
      end
    end

    it 'shows the Edit form' do
      expect(page).to have_content('Edit Candidate Availability')
      expect(page).to have_content('10-2', count: 7)
      expect(page).to have_content('2-6', count: 7)
      expect(page).to have_content('5-9', count: 7)
    end

    describe 'form submission' do
      before(:each) do
        check :candidate_availability_monday_first
        check :candidate_availability_wednesday_first
        check :candidate_availability_friday_first
        click_on 'Save'
      end

      it 'updates the candidate availability' do
        candidate.reload
        expect(candidate.candidate_availability.monday_first).to be(true)
        expect(candidate.candidate_availability.wednesday_first).to be(true)
        expect(candidate.candidate_availability.friday_first).to be(true)
        expect(candidate.candidate_availability.thursday_first).to be(false)
        expect(candidate.candidate_availability.sunday_first).to be(true)
      end

      it 'redirects to the candidate show page' do
        expect(page).to have_content candidate.name
      end

      it 'creates a log entry' do
        expect(page).to have_content 'updated the availability for'
      end
    end

    describe 'for retroactively adding' do
      let!(:candidate_two) { create :candidate }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
        visit candidate_path candidate_two
        within('.widget.availability') do
          click_on 'New'
        end
      end
      it 'shows the New form' do
        expect(page).to have_content('New Candidate Availability')
        expect(page).to have_content('10-2', count: 7)
        expect(page).to have_content('2-6', count: 7)
        expect(page).to have_content('5-9', count: 7)
      end

      describe 'form submission' do
        before(:each) do
          check :candidate_availability_monday_first
          check :candidate_availability_wednesday_first
          check :candidate_availability_friday_first
          click_on 'Save'
        end

        it 'updates the candidate availability' do
          candidate_two.reload
          expect(candidate_two.candidate_availability.monday_first).to be(true)
          expect(candidate_two.candidate_availability.wednesday_first).to be(true)
          expect(candidate_two.candidate_availability.friday_first).to be(true)
          expect(candidate_two.candidate_availability.thursday_first).to be(false)
          expect(candidate_two.candidate_availability.sunday_first).to be(false)
        end

        it 'redirects to the candidate show page' do
          expect(page).to have_content candidate_two.name
        end

        it 'creates a log entry' do
          expect(page).to have_content 'updated the availability for'
        end
      end
    end
  end

end
