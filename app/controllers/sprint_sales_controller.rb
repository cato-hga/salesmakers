require_relative 'sprint_sales/scoreboard_query'

class SprintSalesController < ApplicationController
  include SprintSales::ScoreboardQuery

  before_action :chronic_time_zones
  before_action :set_salesmakers, only: [:new, :create]
  before_action :get_project, only: [:new, :create]
  before_action :do_authorization
  before_action :search_sales, only: [:index, :csv]
  before_action :set_carrier_based_on_project, only: [:new, :create]
  before_action :set_sprint_locations, only: [:new, :create]
  after_action :verify_authorized

  def index
    @last_import = SprintSale.maximum(:created_at)
    @sprint_sales = @sprint_sales.page(params[:page])
    @areas = []
  end

  def csv
    check_for_too_many_records @sprint_sales; return if performed?
    handle_csv 'sprint_sales'
  end

  def show
    @sprint_prepaid = Project.find_by name: 'Sprint Prepaid'
    @star = Project.find_by name: 'STAR'
    @sprint_sale = policy_scope(SprintSale).find params[:id]
  end

  def new
    @sprint_sale = SprintSale.new
    set_template
  end

  def scoreboard
    @client = Client.find_by name: 'Sprint'
    set_depth
    set_range
    set_project
    set_region_name_contains
    set_market_name_contains
    set_territory_name_contains
    set_location_name_contains
    set_sales
  end

  def create
    @sprint_sale = SprintSale.new sprint_sale_params
    @sale_date = params.require(:sprint_sale).permit(:sale_date)[:sale_date]
    chronic_time = Chronic.parse(@sale_date)
    adjusted_time = chronic_time.present? ? chronic_time.in_time_zone : nil
    @sprint_sale.sale_date = adjusted_time
    if @sprint_sale.save
      flash[:notice] = 'Sprint Sale has been successfully created.'
      redirect_to new_sprint_sales_path @project.id
    else
      set_template
    end
  end

  private

  def filter_result result
    if params[:areas_includes_id].blank?
      return result
    end
    result.joins(%{
                    left outer join locations l on l.id = sprint_sales.location_id
                    left outer join location_areas la on la.location_id = l.id
                    left outer join areas a on a.id = la.area_id
                    left outer join projects p on p.id = a.project_id
                  }).where(%{
                    (p.name = 'Sprint Prepaid' OR p.name = 'STAR')
                    and la.active = true
                    and '#{params[:areas_includes_id]}' = ANY (string_to_array(cast(a.id as character varying) || '/' || a.ancestry, '/'))
                  })
  end

  def do_authorization
    authorize SprintSale.new
  end

  def area_params
    params.permit :location_in_area_id
  end

  def search_sales
    set_instance_variables
    sprint_sales = fetch_sprint_sales
    @search = sprint_sales.
        search(params[:q])
    @sprint_sales = @search.
        result.
        joins(:person).
        order("sale_date DESC, people.display_name ASC").
        includes(:person, :location)
  end

  def set_instance_variables
    @sprint_carriers = SprintCarrier.all.order(:name)
    @sprint_handsets = SprintHandset.all.order(:name)
    @sprint_rate_plans = SprintRatePlan.all.order(:name)
    @sprint_prepaid = Project.find_by name: 'Sprint Prepaid'
    @star = Project.find_by name: 'STAR'
    @projects = Project.where("name = ? OR name = ?", 'Sprint Prepaid', 'STAR').includes(:areas, :client)
    @area_id = area_params[:location_in_area_id]
  end

  def fetch_sprint_sales
    area = @area_id.blank? ? nil : Area.find(@area_id)
    if area && !area.descandant_ids.empty?
      sprint_sales.
          joins(location: :location_areas).
          where("location_areas.area_id IN (#{area.descendant_ids.join(',')})")
    elsif area && area.descendant_ids.empty?
      sprint_sales.none
    else
      policy_scope(SprintSale)
    end
  end

  def set_salesmakers
    @salesmakers = @current_person.managed_team_members.sort_by { |n| n[:display_name] }
    @salesmakers = [@current_person] if @salesmakers.empty?
  end

  def get_project
    @project = Project.find params[:project_id]
  end

  def sprint_sale_params
    params.require(:sprint_sale).permit :person_id,
                                        :location_id,
                                        :meid,
                                        :meid_confirmation,
                                        :mobile_phone,
                                        :sprint_carrier_id,
                                        :sprint_handset_id,
                                        :upgrade,
                                        :sprint_rate_plan_id,
                                        :top_up_card_purchased,
                                        :top_up_card_amount,
                                        :phone_activated_in_store,
                                        :reason_not_activated_in_store,
                                        :number_of_accessories,
                                        :picture_with_customer,
                                        :comments,
                                        :five_intl_connect,
                                        :ten_intl_connect,
                                        :insurance,
                                        :virgin_data_share_add_on_amount,
                                        :virgin_data_share_add_on_description,
                                        :project_id,
                                        :photo
  end

  def set_carrier_based_on_project
    @carriers = @project.sprint_carriers
  end

  def set_template
    if @project.name == 'Sprint Prepaid'
      render :new_prepaid
    else
      render :new_star
    end
  end

  def set_sprint_locations
    if @current_person.position.all_field_visibility?
      @sprint_locations = @project.locations.ordered_by_name
    else
      @sprint_locations = @project.locations_for_person @current_person
    end
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end

  def set_depth
    @depth = params[:depth] ? params[:depth].to_i : 6
  end

  def set_range
    @range = [Date.today, Date.today]
    if params[:start_date] && params[:end_date]
      @range = [Chronic.parse(params[:start_date]), Chronic.parse(params[:end_date])]
    end
    unless @range.first and @range.last
      @range = [Date.today, Date.today]
      flash[:error] = 'You have either entered an invalidate start date or end date. Please re-enter the dates.'
    end
  end

  def set_project
    @project = nil
    @project = Project.find params[:project_id] unless params[:project_id].blank?
  end

  def set_region_name_contains
    @region_name_contains = ''
    @region_name_contains = params[:region_name_contains] unless params[:region_name_contains].blank?
  end

  def set_market_name_contains
    @market_name_contains = ''
    @market_name_contains = params[:market_name_contains] unless params[:market_name_contains].blank?
  end

  def set_territory_name_contains
    @territory_name_contains = ''
    @territory_name_contains = params[:territory_name_contains] unless params[:territory_name_contains].blank?
  end

  def set_location_name_contains
    @location_name_contains = ''
    @location_name_contains = params[:location_name_contains] unless params[:location_name_contains].blank?
  end

  def set_sales
    @query = query
    @sales = ActiveRecord::Base.connection.execute @query
    @search = OpenStruct.new(result: @sales)
  end
end