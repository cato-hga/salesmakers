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
    set_day_sales_counts
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
    @project = Project.find params[:project_id] if params[:project_id]
  end

  def set_day_sales_counts
    @day_sales_counts = ActiveRecord::Base.connection.execute query
    @search = OpenStruct.new(result: @day_sales_counts)
  end
end