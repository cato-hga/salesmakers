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

  def view_all?
    has_permission? 'view_all'
  end

  def show?
    index?
  end

  def support_search?
    view_all?
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

  def edit_candidate_details?
    create?
  end

  def update_candidate_details?
    create?
  end

  def dismiss?
    create?
  end

  def record_assessment_score?
    record_assessment?
  end

  def record_assessment?
    has_permission? 'record_assessment'
  end

  def resend_assessment?
    set_location_area?
  end

  def reactivate?
    create?
  end

  def dashboard?
    has_permission? 'view_all'
  end

  def cant_make_training_location?
    create?
  end

  def welcome_call?
    create?
  end

  def record_welcome_call?
    create?
  end

  def set_sprint_radio_shack_training_session?
    view_all?
  end

  def set_training_session_status?
    view_all?
  end

  def set_reconciliation_status?
    hr_admin = Position.find_by name: 'Human Resources Administrator'
    return true if @user.position == hr_admin
    false
  end
end