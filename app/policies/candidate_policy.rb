class CandidatePolicy < ApplicationPolicy
  class Scope < Struct.new(:person, :scope)
    def resolve
      scope
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
end