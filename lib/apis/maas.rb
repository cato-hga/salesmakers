class Maas
  include HTTParty
  base_uri 'https://services.fiberlink.com'
  format :xml
  headers({ 'Content-Type' => 'application/xml', 'Accept' => 'application/xml'})

  require 'open-uri'
  require 'nokogiri'

  def initialize
    @username = 'it@retaildoneright.com'
    @password = 'qO7@vDtt'
    @billing_id = '1068247'
    @platform_id = '3'
    @app_name = '1068247_RBD'
    @app_id = 'com.1068247.rbd'
    @app_version = '1.0'
    @app_access_key = 'iqu5zKJYBg'
    auth
  end

  def auth
    o = Nokogiri::XML::Builder.new do |x|
      x.authRequest {
        x.maaS360AdminAuth {
          x.billingID @billing_id
          x.platformID @platform_id
          x.appID @app_id
          x.appVersion @app_version
          x.appAccessKey @app_access_key
          x.userName @username
          x.password @password
        }
      }
    end
    puts o.to_xml
    response = self.class.post '/auth-apis/auth/1.0/authenticate/' + @billing_id, body: o.to_xml
    if response['authResponse'] and response['authResponse']['authToken']
      @auth_token = response['authResponse']['authToken']
    else
      @auth_token = nil
    end
  end

end