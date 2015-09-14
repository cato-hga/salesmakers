class ShiftsController < ApplicationController
  after_action :verify_policy_scoped, only: [:index]

  def index
    @projects = Project.visible(@current_person).includes(:areas, :client)
    people = policy_scope(Person)
    @area_id = area_params[:location_in_area_id]
    area = @area_id.blank? ? nil : Area.find(@area_id)
    people_shifts = Shift.where(person: people)
    if area
      if area.descendant_ids.empty?
        people_shifts = people_shifts.none
      else
        people_shifts = people_shifts.
            joins(location: :location_areas).
            where("location_areas.area_id IN (#{area.descendant_ids.join(',')})")
      end
    end
    @search = people_shifts.
        search(params[:q])
    @shifts = @search.
        result.
        joins(:person).
        order("shifts.date DESC, people.display_name ASC").
        page(params[:page]).
        includes(:location, person: :person_areas)
  end

  private

  def area_params
    params.permit :location_in_area_id
  end

end
