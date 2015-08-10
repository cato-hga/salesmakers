class Maas
  include HTTParty

  base_uri 'https://services.fiberlink.com'
  format :xml
  headers({ 'Content-Type' => 'application/xml', 'Accept' => 'application/xml' })

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
    response = self.class.post '/auth-apis/auth/1.0/authenticate/' + @billing_id, body: o.to_xml
    if response['authResponse'] and response['authResponse']['authToken']
      @auth_token = response['authResponse']['authToken']
    else
      @auth_token = nil
    end
  end

  def meid_search meid
    doGet '/device-apis/devices/1.0/search', { imeiMeid: meid }
  end

  def meid_and_username_search meid, username
    doGet '/device-apis/devices/1.0/search', { imeiMeid: meid, partialUsername: username }
  end

  def security_and_compliance_attributes maas_360_device_id
    doGet '/device-apis/devices/1.0/mdSecurityCompliance', { deviceId: maas_360_device_id }
  end

  def change_device_policy maas_360_device_id, new_policy_name
    doPostForm '/device-apis/devices/1.0/changeDevicePolicy', {
                                                                'maas360DeviceId' => maas_360_device_id,
                                                                'policyName' => new_policy_name
                                                            }
  end

  def doGet(path, query = nil)
    self.class.get path + '/' + @billing_id, {
                                               query: query, headers: {
                                                   'Content-Type' => 'application/xml',
                                                   'Accept' => 'application/xml',
                                                   'Authorization' => 'MaaS token="' + @auth_token + '"'
                                               }
                                           }
  end

  def doPost(path, body, query = nil)
    self.class.post path + '/' + @billing_id, {
                                                body: body, query: query, headers: {
                                                    'Content-Type' => 'application/xml',
                                                    'Accept' => 'application/xml',
                                                    'Authorization' => 'MaaS token="' + @auth_token + '"'
                                                }
                                            }
  end

  def doPostForm(path, form_parameters = {}, query = nil)
    uri = Addressable::URI.new
    uri.query_values = form_parameters
    body = uri.query
    self.class.post path + '/' + @billing_id, {
                                                body: body, query: query, headers: {
                                                    'Content-Type' => 'application/x-www-form-urlencoded',
                                                    'Accept' => 'application/xml',
                                                    'Authorization' => 'MaaS token="' + @auth_token + '"'
                                                }
                                            }
  end

end