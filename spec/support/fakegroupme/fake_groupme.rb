require 'sinatra/base'

class FakeGroupMe < Sinatra::Base

  get '/v3/groups' do
    json_response 200, 'get_groups.json'
  end

  get '/v3/groups/:id' do
    json_response 200, 'get_group.json'
  end

  post '/v3/groups' do
    json_response 201, 'create_group.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/' + file_name, 'rb').read
  end
end