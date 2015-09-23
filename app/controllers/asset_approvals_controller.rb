class AssetApprovalsController < ApplicationController

  def approval
    authorize Person.new
    @team = @current_person.managed_team_members
    get_people
    @pending_approval = Person.no_assets_from_collection(@people)
  end

  def approve
    set_status('approved')
  end

  def deny
    set_status('denied')
  end

  private

  def set_status(status)
    @person = Person.find params[:person_id]
    project_name = @person.person_areas.first.area.project.name
    if project_name.include? 'Sprint Prepaid'
      @person.update sprint_prepaid_asset_approval_status: "prepaid_#{status}".to_sym
    else
      @person.update vonage_tablet_approval_status: "#{status}".to_sym
    end
    flash[:notice] = "Employee has been marked as #{status} for asset"
    redirect_to asset_approval_path
  end

  def get_people
    @people = []
    for member in @team do
      project_name = member.person_areas.first.area.project.name
      if project_name == 'Sprint Prepaid'
        @people << member if member.passed_asset_hours_requirement and member.sprint_prepaid_asset_approval_status == 'prepaid_no_decision'
      end
      if project_name.include? 'Vonage'
        @people << member if member.passed_asset_hours_requirement and member.vonage_tablet_approval_status == 'no_decision'
      end
    end
    @people
  end

end
