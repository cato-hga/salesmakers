require 'docusign_rest'

DocusignRest.configure do |config|
  config.username = 'it@retaildoneright.com'
  config.password = 'reta!lPr0s'
  config.integrator_key = 'RETA-116c6b7d-09cf-4c4e-876c-65cbf19aaacc'
  config.account_id = '6307293'
  config.endpoint = 'https://www.docusign.net/restapi'
  config.api_version = 'v2'
end