class ReportQueryPolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      reports = []
      for query in scope.all do
        perm = Permission.find_by key: query.permission_key
        next unless perm
        if person.permissions.include? perm
          reports << query
        end
      end
      return scope.none if reports.empty?
      scope.where("id IN (#{reports.map(&:id).join(',')})")
    end
  end

  def show?
    if record.respond_to? :permission_key
      has_key? user, record.permission_key
    else
      false
    end
  end

  def csv?
    show?
  end
end