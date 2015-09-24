class ShiftsController < ApplicationController
  after_action :verify_policy_scoped, only: [:index]
  before_action :shift_search, only: [:index, :csv]

  def index
    @shifts = @shifts.
        page(params[:page]).
        includes(:location, person: :person_areas)
  end

  def csv
    if @shifts.count >= 10000
      flash[:error] = 'There were more than 10,000 shifts returned from your search. This is too large. ' +
          'Please further refine your search to export the shifts to CSV.'
      redirect_to :back and return
    end
    respond_to do |format|
      format.html { redirect_to self.send((controller_name + '_path').to_sym) }
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"vonage_sales_#{date_time_string}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  private

  def area_params
    params.permit :location_in_area_id
  end

  def shift_search
    @projects = Project.visible(@current_person).includes(:areas, :client)
    people_shifts = policy_scope(Shift)
    @area_id = area_params[:location_in_area_id]
    area = @area_id.blank? ? nil : Area.find(@area_id)
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
        order("shifts.date DESC, people.display_name ASC")
  end
end
