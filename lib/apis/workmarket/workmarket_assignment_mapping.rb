class WorkmarketAssignmentMapping
  include Kartograph::DSL

  kartograph do
    mapping WorkmarketAssignment

    scoped :read do
      property :workmarket_assignment_num, key: 'id'
      property :title
    end
  end
end