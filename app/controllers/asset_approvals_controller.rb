class AssetApprovalsController < ApplicationController

  def approval
    @people = @current_person.managed_team_members
    @people = @people.where(passed_asset_hours_requirement: true)
    @pending_approval = Person.no_tablets_from_collection(@people)
  end

  def approve
    @person = Person.find params[:person_id]
    @person.update vonage_tablet_approval_status: :approved
    flash[:notice] = 'Employee approved for tablet'
    render :approval
  end

  def deny
    @person = Person.find params[:person_id]
    @person.update vonage_tablet_approval_status: :denied
    flash[:notice] = 'Employee approved for tablet'
    render :approval
  end

end
