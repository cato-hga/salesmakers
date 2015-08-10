class WorkmarketListedAssignment
  attr_accessor :workmarket_assignment_num
end

class WorkmarketListedAssignmentMapping
  include Kartograph::DSL

  kartograph do
    mapping WorkmarketListedAssignment

    property :workmarket_assignment_num, key: 'id', scopes: [:read]
  end
end