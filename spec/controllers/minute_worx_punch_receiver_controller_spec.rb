require 'rails_helper'

describe MinuteWorxPunchReceiverController do

  describe 'POST begin' do
    before { post :begin, "{}", format: :json }

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

end