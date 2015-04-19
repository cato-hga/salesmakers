class WorkmarketFieldMapping
  include Kartograph::DSL

  kartograph do
    mapping WorkmarketField

    scoped :read do
      property :name
      property :value
    end
  end
end