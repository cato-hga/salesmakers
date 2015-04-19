class WorkmarketClient
  attr_accessor :workmarket_client_num
end

class WorkmarketClientMapping
  include Kartograph::DSL

  kartograph do
    mapping WorkmarketClient

    scoped :read do
      property :workmarket_client_num, key: 'id'
    end
  end
end