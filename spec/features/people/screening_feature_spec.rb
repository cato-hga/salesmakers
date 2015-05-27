require 'rails_helper'

describe 'employee screenings' do
  let(:hr_person) {
    create :person,
           position: hr_position
  }
  let(:unauth_person) { create :person }
  let(:permission) {
    create :permission,
           key: 'screening_update'
  }
  let(:view) { create :permission, key: 'candidate_index' }
  let(:hr_position) {
    create :position,
           permissions: [permission, view],
           all_corporate_visibility: true,
           all_field_visibility: true
  }
  let(:person) { create :person }
  let!(:candidate) { create :candidate, person: person, status: :onboarded }
  let!(:candidate_denial_reason) {
    create :candidate_denial_reason,
           name: 'Did not pass employment screening'
  }

  context 'for unauthorized people' do
    before do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit edit_person_screening_path(person)
    end

    it 'shows the "You are not authorized" page' do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  context 'for authorized people' do
    before do
      CASClient::Frameworks::Rails::Filter.fake(hr_person.email)
      visit person_path(person)
      click_on 'Edit Screening'
      select 'Sex Offender Check Passed', from: 'Sex offender check'
      select 'Public Background Check Passed', from: 'Public background check'
      select 'Private Background Check Passed', from: 'Private background check'
      select 'Drug Screening Passed', from: 'Drug screening'
    end

    it 'has the correct page title' do
      expect(page).to have_selector('h1', text: "Screening for #{person.name}")
    end

    it 'saves the screening info' do
      click_on 'Save'
      expect(Screening.count).to eq(1)
      screening = Screening.first
      expect(screening.sex_offender_check).to eq('sex_offender_check_passed')
      expect(screening.public_background_check).to eq('public_background_check_passed')
      expect(screening.private_background_check).to eq('private_background_check_passed')
      expect(screening.drug_screening).to eq('drug_screening_passed')
    end

    it 'updates the candidate status to partially_screened when not all done' do
      select 'Drug Screening Sent', from: 'Drug screening'
      click_on 'Save'
      candidate.reload
      expect(candidate.status).to eq('partially_screened')
    end

    it 'updates the candidate status to fully_screened when done' do
      click_on 'Save'
      candidate.reload
      expect(candidate.status).to eq('fully_screened')
    end

    it 'rejects the candidate when they fail a portion of screening' do
      select 'Private Background Check Failed', from: 'Private background check'
      click_on 'Save'
      candidate.reload
      expect(candidate.status).to eq('rejected')
      expect(candidate.candidate_denial_reason).to eq(candidate_denial_reason)
    end

    it 'creates a log entry when a person fails the screening' do
      select 'Private Background Check Failed', from: 'Private background check'
      click_on 'Save'
      candidate.reload
      candidate.person.reload
      visit person_path(candidate.person)
      save_and_open_page
      expect(page).to have_content 'Was marked as failing their screening by'
      visit candidate_path(candidate)
      save_and_open_page
      expect(page).to have_content 'Was marked as failing their screening by'
    end
  end

  context 'for updating a current screening' do
    let!(:screen) { create :screening, person: person, sex_offender_check: 1, public_background_check: 1, private_background_check: 1, drug_screening: 1 }
    it 'updates correctly' do
      expect(Screening.count).to eq(1)
      expect(person.screening.sex_offender_check).to eq('sex_offender_check_failed')
      expect(person.screening.public_background_check).to eq('public_background_check_failed')
      expect(person.screening.private_background_check).to eq('private_background_check_initiated')
      expect(person.screening.drug_screening).to eq('drug_screening_sent')
      CASClient::Frameworks::Rails::Filter.fake(hr_person.email)
      visit person_path(person)
      click_on 'Edit Screening'
      select 'Sex Offender Check Passed', from: 'Sex offender check'
      select 'Public Background Check Passed', from: 'Public background check'
      select 'Private Background Check Passed', from: 'Private background check'
      select 'Drug Screening Passed', from: 'Drug screening'
      click_on 'Save'
      expect(Screening.count).to eq(1)
      person.reload
      expect(person.screening.sex_offender_check).to eq('sex_offender_check_passed')
      expect(person.screening.public_background_check).to eq('public_background_check_passed')
      expect(person.screening.private_background_check).to eq('private_background_check_passed')
      expect(person.screening.drug_screening).to eq('drug_screening_passed')
      visit person_path(person)
      click_on 'Edit Screening'
      select 'Sex Offender Check Failed', from: 'Sex offender check'
      select 'Public Background Check Failed', from: 'Public background check'
      select 'Private Background Check Failed', from: 'Private background check'
      select 'Drug Screening Failed', from: 'Drug screening'
      click_on 'Save'
      person.reload
      person.screening.reload
      expect(person.screening.sex_offender_check).to eq('sex_offender_check_failed')
      expect(person.screening.public_background_check).to eq('public_background_check_failed')
      expect(person.screening.private_background_check).to eq('private_background_check_failed')
      expect(person.screening.drug_screening).to eq('drug_screening_failed')
    end
  end

end