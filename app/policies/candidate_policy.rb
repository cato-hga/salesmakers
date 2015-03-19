class CandidatePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      # return scope.none unless person.position
      # permission = Permission.find_by key: 'candidate_view_all'
      # if permission and person.position.permissions.include? permission
      #   scope.all
      # else
      #   scope.where(created_by: person)
      # end
      scope.all # This is because candidates are being exchanged between recruiters
    end
  end

  def show?
    index?
  end

  def time_slots?
    create?
  end

  def schedule?
    create?
  end

  def select_location?
    create?
  end

  def set_location_area?
    select_location?
  end

  def confirm_location?
    select_location?
  end

  def send_paperwork?
    create?
  end

  def interview_now?
    create?
  end

  def new_sms_message?
    create_sms_message?
  end

  def create_sms_message?
    create?
  end

  def select_person?
    create?
  end

  def link_person?
    select_person?
  end

  def destroy?
    create?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def dismiss?
    create?
  end

  def passed_assessment?
    update?
  end

  def failed_assessment?
    update?
  end
end