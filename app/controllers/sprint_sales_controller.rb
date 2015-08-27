require_relative 'sprint_sales/scoreboard_query'

class SprintSalesController < ApplicationController
  include SprintSales::ScoreboardQuery

  before_action :chronic_time_zones
  before_action :set_salesmakers, only: [:new, :create]
  before_action :get_project, only: [:new, :create]
  before_action :do_authorization
  before_action :set_sprint_locations, only: [:new, :create]
  after_action :verify_authorized

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
    sale_date = params.require(:sprint_sale).permit(:sale_date)[:sale_date]
    chronic_time = Chronic.parse(sale_date)
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

  def do_authorization
    authorize SprintSale.new
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
                                        :carrier_name,
                                        :handset_model_name,
                                        :upgrade,
                                        :rate_plan_name,
                                        :top_up_card_purchased,
                                        :top_up_card_amount,
                                        :phone_activated_in_store,
                                        :reason_not_activated_in_store,
                                        :picture_with_customer,
                                        :comments
  end

  def set_template
    if @project.name == 'Sprint Retail'
      render :new_prepaid
    else
      render :new_postpaid
    end
  end

  def set_sprint_locations
    if @current_person.position.all_field_visibility?
      sprint = Project.find_by name: 'Sprint Retail'
      return Location.none unless sprint
      @sprint_locations = sprint.locations
    else
      sprint = Project.find_by name: 'Sprint Retail'
      return Location.none unless sprint
      @sprint_locations = sprint.locations_for_person @current_person
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