require 'rails_helper'
require 'apis/groupme'

describe MinuteWorxPunchReceiverController do

  describe 'POST begin' do
    let(:person) { create :person }

    let(:json) {
      {
          'Employee': {
              'email_work': person.email
          },
          'Punch': {
              'timestamp': DateTime.now.strftime('%Y-%m-%dT%H:%M:%S%:z'),
              'punch_type_text': 'Punched In'
          }
      }.to_json
    }

    subject { post :begin, data: json, format: :json }

    it 'returns a success status' do
      subject
      expect(response).to be_success
    end

    it 'creates a PersonPunch' do
      expect {
        subject
      }.to change(PersonPunch, :count).by 1
    end

    it 'saves the punch type correctly' do
      subject
      expect(PersonPunch.first.in_or_out).to eq 'in'
    end

    it 'saves the person correctly' do
      subject
      expect(PersonPunch.first.person).to eq person
    end

    describe 'with a GroupMe group' do
      let(:area) { create :area }
      let!(:group_me_group) { create :group_me_group, area: area }

      before do
        PersonArea.create person: person, area: area
      end

      it 'sends a GroupMe message' do
        message = "#{person.display_name} just punched in."
        expect_any_instance_of(GroupMeGroup).to receive(:send_message).with(message)
        subject
      end
    end
  end
end