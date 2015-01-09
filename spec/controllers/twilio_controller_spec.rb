require 'rails_helper'

describe TwilioController do

  describe 'POST incoming' do
    before { post :incoming_voice, 'From' => '+18635214572' }

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

end