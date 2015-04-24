class AssetApprovalsController < ApplicationController

  def approval
    authorize Person.new
    team = @current_person.managed_team_members
    people = []
    for member in team do
      people << member if member.passed_asset_hours_requirement and member.vonage_tablet_approval_status == 'no_decision'
    end
    @pending_approval = Person.no_tablets_from_collection(people)
  end

  def approve
    @person = Person.find params[:person_id]
    @person.update vonage_tablet_approval_status: :approved
    flash[:notice] = 'Employee approved for tablet'
    redirect_to asset_approval_path
  end

  def deny
    @person = Person.find params[:person_id]
    @person.update vonage_tablet_approval_status: :denied
    flash[:notice] = 'Employee has been marked as "denied"'
    redirect_to asset_approval_path
  end

end
