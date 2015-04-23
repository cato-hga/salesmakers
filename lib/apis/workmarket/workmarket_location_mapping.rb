class WorkmarketLocationMapping
  include Kartograph::DSL

  kartograph do
    mapping WorkmarketLocation

    scoped :read do
      property :workmarket_location_num, key: 'id'
      property :name
      property :location_number
    end
  end
end