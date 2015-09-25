class RingCentral
  attr_reader :client

  def initialize
    sdk = RingCentralSdk::Sdk.new 'PYaIDHBuRUCMQaNK8cCxOA',
                                  'jvci1rroReKuHWSR6SYpEQ0BIWaWjiQeG54fd-hGzekA',
                                  RingCentralSdk::Sdk::RC_SERVER_PRODUCTION
    platform = sdk.platform
    platform.authorize '+16505496111', nil, 'Al995nir!'
    # TODO: production login
    # platform.authorize '+19543027800', nil, 'readyT0G0'
    @hash = platform.token.to_hash
    @client = platform.client
  end

  def call_logs start_date = Date.today, end_date = Date.tomorrow, type = 'Voice'
    response = client.get do |request|
      request.url 'account/~/call-log'
      request.params['dateFrom'] = start_date.strftime('%Y-%m-%d')
      request.params['dateTo'] = end_date.strftime('%Y-%m-%d')
      request.params['type'] = type
    end
    response.andand.body.andand['records']
  end
end