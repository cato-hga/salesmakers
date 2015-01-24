require 'rails_helper'

describe FeedbacksController do

  describe 'GET new' do
    it 'returns a success status' do
      get :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:person) { create :person }
    it 'creates feedback' do
      request.env['HTTP_REFERER'] = root_path
      post :create,
           feedback: {
               person: person.display_name,
               email: person.email,
               position: person.position.name,
               subject: 'This is test feedback',
               message: 'This is some feedback that you need to see.',
               nickname: 'Admin'
           }
      expect(response).to redirect_to(root_path)
      # TODO: Testing for flash[:notice] presence failing?
    end
  end

end