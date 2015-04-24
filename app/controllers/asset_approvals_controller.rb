class AssetApprovalsController < ApplicationController

  def approval
    authorize Person.new
    team = @current_person.managed_team_members
    people = []
    for member in team do
      project_name = member.person_areas.first.area.project.name
      if project_name == 'Sprint Retail'
        people << member if member.passed_asset_hours_requirement and member.sprint_prepaid_asset_approval_status == 'prepaid_no_decision'
      end
      if project_name.include? 'Vonage'
        people << member if member.passed_asset_hours_requirement and member.vonage_tablet_approval_status == 'no_decision'
      end
    end
    @pending_approval = Person.no_assets_from_collection(people)
  end

  def approve
    @person = Person.find params[:person_id]
    project_name = @person.person_areas.first.area.project.name
    if project_name.include? 'Sprint Retail'
      @person.update sprint_prepaid_asset_approval_status: :prepaid_approved
    else
      @person.update vonage_tablet_approval_status: :approved
    end
    flash[:notice] = 'Employee approved for asset'
    redirect_to asset_approval_path
  end

  def deny
    @person = Person.find params[:person_id]
    project_name = @person.person_areas.first.area.project.name
    if project_name.include? 'Sprint Retail'
      @person.update sprint_prepaid_asset_approval_status: :prepaid_denied
    else
      @person.update vonage_tablet_approval_status: :denied
    end
    flash[:notice] = 'Employee has been marked as "denied"'
    redirect_to asset_approval_path
  end

end
