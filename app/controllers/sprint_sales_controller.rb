require_relative 'sprint_sales/scoreboard_query'

class SprintSalesController < ApplicationController
  include SprintSales::ScoreboardQuery

  before_action :do_authorization
  after_action :verify_authorized

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

  private

  def do_authorization
    authorize SprintSale.new
  end

  def set_depth
    @depth = params[:depth] ? params[:depth].to_i : 6
  end

  def set_range
    @range = [Date.today, Date.today]
    if params[:start_date] && params[:end_date]
      @range = [Chronic.parse(params[:start_date]), Chronic.parse(params[:end_date])]
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