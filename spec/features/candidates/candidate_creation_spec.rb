require 'rails_helper'
describe 'Candidate creation', :vcr do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_select_location, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_select_location) { Permission.new key: 'candidate_select_location',
                                                    permission_group: permission_group,
                                                    description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let!(:permission_vip) { Permission.new key: 'candidate_vip',
                                         permission_group: permission_group,
                                         description: 'Test Description' }
  let(:location) { create :location }
  let!(:project) { create :project, name: 'Comcast Retail' }
  let!(:source) { create :candidate_source }
  let!(:outsourced) { create :candidate_source, name: 'Outsourced' }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit new_candidate_path
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      visit new_candidate_path
    end
    it 'has the new candidate form with all fields' do
      within '#content' do
        expect(page).to have_content('First name')
        expect(page).to have_content('Last name')
        expect(page).to have_content('Suffix')
        expect(page).to have_content('Mobile phone')
        expect(page).to have_content('Other phone')
        expect(page).to have_content('Email address')
        expect(page).to have_content('Zip Code')
        expect(page).to have_content('Candidate source')
        expect(page).to have_button 'Save and Select Location'
        expect(page).to have_content 'Save, left voicemail'
      end
    end

    describe 'form submission' do
      context 'with invalid data' do
        it 'shows all relevant error messages' do
          click_on 'Save and Select Location'
          expect(page).to have_content "First name can't be blank"
          expect(page).to have_content "Last name can't be blank"
          expect(page).to have_content "Mobile phone is the wrong length"
          expect(page).to have_content "Email can't be blank"
          expect(page).to have_content "Zip is the wrong length"
        end
      end

      context 'with valid data' do
        context 'for VIPs' do
          let!(:vip_source) { create :candidate_source, name: 'Project VIP' }

          specify 'the form does not show the Project VIP Source unless the current person has the permission' do
            within '#content' do
              expect(page).not_to have_content 'Project VIP'
            end
            position.permissions << permission_vip
            visit new_candidate_path
            within '#content' do
              expect(page).to have_content 'Project VIP'
            end
          end

          it 'sets the candidate as a VIP if the Project VIP source is selected' do
            position.permissions << permission_vip
            visit new_candidate_path
            within '#content' do
              fill_in 'First name', with: 'Test'
              fill_in 'Last name', with: 'Candidate'
              fill_in 'Mobile phone', with: '727-498-5180'
              fill_in 'Email address', with: 'test@test.com'
              fill_in 'Zip Code', with: '33701'
              select vip_source.name, from: 'Candidate source'
              click_on 'Save and Select Location'
            end
            candidate = Candidate.first
            expect(candidate.vip).to eq(true)
          end
        end

        context 'for outsourced employees' do
          before(:each) do
            within '#content' do
              fill_in 'First name', with: 'Test'
              fill_in 'Last name', with: 'Candidate'
              fill_in 'Mobile phone', with: '727-498-5180'
              fill_in 'Email address', with: 'test@test.com'
              fill_in 'Zip Code', with: '33701'
              select outsourced.name, from: 'Candidate source'
              click_on 'Save and Select Location'
            end
          end

          it 'displays a flash message' do
            expect(page).to have_content 'Outsourced candidate saved!'
          end
          it 'redirects to the prescreen questions page' do
            expect(page).to have_content 'Select Location for'
          end
          it 'does not have the candidate as a VIP' do
            candidate = Candidate.first
            expect(candidate.vip).to eq(false)
          end
        end

        context 'and selecting location' do
          before(:each) do
            within '#content' do
              fill_in 'First name', with: 'Test'
              fill_in 'Last name', with: 'Candidate'
              fill_in 'Mobile phone', with: '727-498-5180'
              fill_in 'Email address', with: 'test@test.com'
              fill_in 'Zip Code', with: '33701'
              select source.name, from: 'Candidate source'
            end
          end

          context 'for candidates without an alternate phone number' do
            before { click_on 'Save and Select Location' }

            it 'displays a flash message' do
              expect(page).to have_content 'Candidate saved!'
            end

            it 'redirects to the location selection page' do
              expect(page).to have_content 'Select Location for '
            end
          end

          context 'for candidates with an alternate phone number' do
            before do
              fill_in 'Other phone', with: '8005551002'
              click_on 'Save and Select Location'
            end

            it 'displays a flash message' do
              expect(page).to have_content 'Candidate saved!'
            end

            it 'redirects to the location selection page' do
              expect(page).to have_content 'Select Location for '
            end

            it 'saves the other phone number' do
              expect(Candidate.first.other_phone).to eq('8005551002')
            end
          end
        end

        context 'and leaving voicemail' do
          before(:each) do
            within '#content' do
              fill_in 'First name', with: 'Test'
              fill_in 'Last name', with: 'Candidate'
              fill_in 'Mobile phone', with: '727-498-5180'
              fill_in 'Email address', with: 'test@test.com'
              fill_in 'Zip Code', with: '33701'
              select source.name, from: 'Candidate source'
              find(:xpath, "//input[@id='select_location']").set false
              click_on 'Save and Select Location'
            end
          end
          it 'displays a flash message' do
            expect(page).to have_content 'Candidate saved!'
          end
          it 'redirects to the candidate index' do
            expect(page).to have_content 'Candidates'
            within('header h1') do
              expect(page).not_to have_content 'Select Location for'
            end
          end
          it "creates an outbound contact log, with a note 'Left Voicemail'" do
            candidate = Candidate.first
            visit candidate_path candidate
            expect(page).to have_content 'Left Voicemail'
          end
          it 'sets the candidate contact datetime correctly' do
            expect(CandidateContact.first.created_at).to be_within((2).second).of(Time.now)
            candidate = Candidate.first
            visit candidate_path candidate
            expect(page).to have_content Time.zone.now.strftime('%l:%M%P %Z')
          end
          it 'does not have the candidate as a VIP' do
            candidate = Candidate.first
            expect(candidate.vip).to eq(false)
          end
        end
      end

      # context 'with invalid phone numbers' do
      #   before(:each) do
      #     within '#content' do
      #       fill_in 'First name', with: 'Test'
      #       fill_in 'Last name', with: 'Candidate'
      #       fill_in 'Email address', with: 'test@test.com'
      #       fill_in 'Zip Code', with: '33701'
      #       select source.name, from: 'Candidate source'
      #     end
      #   end
      #
      #   subject { click_on 'Save and Select Location' }
      #
      #   it 'handles an invalid phone number filled out on Mobile phone' do
      #     fill_in 'Mobile phone', with: '8631234567'
      #     subject
      #     expect(page).to have_content 'Mobile phone number is not an active phone number'
      #   end
      #
      #   it 'handles an invalid phone number filled out on Other phone' do
      #     fill_in 'Other phone', with: '8631234567'
      #     subject
      #     expect(page).to have_content 'Other phone number is not an active phone number'
      #   end
      #
      #   it 'handles a non-mobile phone number filled out on Mobile phone' do
      #     fill_in 'Mobile phone', with: '8634396520'
      #     subject
      #     expect(page).to have_content 'Mobile phone number is a landline. Please move the number to the "Other phone" field and get a valid mobile phone number from the candidate.'
      #   end
      # end
    end
  end
end
