class ReportQueriesController < ApplicationController
  after_action :verify_authorized, except: [:index]

  def index
    @report_query_categories = policy_scope(ReportQuery).all.group_by { |q| q.category_name }
  end

  def show
    @report_query = ReportQuery.find params[:id]
    if @report_query.has_date_range? && @report_query.start_date_default
      @start_date = params[:start_date] ? params[:start_date] : Date.today.public_send(@report_query.start_date_default).strftime('%m/%d/%Y')
      @end_date = params[:end_date] ? params[:end_date] : Date.today.strftime('%m/%d/%Y')
    end
    database_connection = get_database_connection
    authorize @report_query
    query = @report_query.query
    if @start_date && @end_date
      query = query.
          gsub('#{start_date}', @start_date).
          gsub('#{end_date}', @end_date)
    end
    @results = database_connection.select_all query
  end

  def csv
    @report_query = ReportQuery.find params[:id]
    authorize @report_query
    database_connection = get_database_connection
    results = database_connection.select_all @report_query.query
    csv_string = CSV.generate col_sep: ',' do |csv|
      csv << results.columns
      results.rows.each do |result|
        csv << result
      end
    end
    filename = @report_query.name.downcase.gsub(/[^0-9a-zA-Z]/, '_') +
        Time.now.in_time_zone.strftime('_%m%d%Y_%H%M%S') +
        '.csv'
    respond_to do |format|
      format.csv { send_data csv_string, filename: filename }
    end
  end

  def new
    authorize ReportQuery.new
    @report_query = ReportQuery.new
  end

  def create
    authorize ReportQuery.new
    @report_query = ReportQuery.new report_query_params
    @report_query.category_name = NameCase(@report_query.category_name)
    @report_query.permission_key = @report_query.permission_key.downcase
    if @report_query.save
      @permission_group = PermissionGroup.find_or_create_by name: "#{@report_query.category_name} Reports"
      @permission = Permission.find_or_create_by description: 'Report queries: ' + @report_query.name,
                                                 permission_group: @permission_group,
                                                 key: @report_query.permission_key
      @current_person.log? 'create',
                           @report_query
      flash[:notice] = 'Report saved.'
      redirect_to new_report_query_path # TODO: Change to index
    else
      render :new
    end
  end

  def edit
    authorize ReportQuery.new
    @report_query = ReportQuery.find params[:id]
  end

  def update
    authorize ReportQuery.new
    @report_query = ReportQuery.find params[:id]
    if @report_query.update report_query_params
      @current_person.log? 'update',
                           @report_query
      flash[:notice] = 'Report saved.'
      redirect_to report_queries_path
    else
      render :edit
    end
  end

  private

  def get_database_connection
    case @report_query.database_name
      when 'mssql'
        MSSQLDatabaseConnection.establish_connection(:mssql).connection
      when 'rbd_erp'
        ConnectDatabaseConnection.establish_connection(:rbd_connect_production).connection
      else
        ActiveRecord::Base.connection
    end
  end

  def report_query_params
    params.require(:report_query).permit :name,
                                         :category_name,
                                         :database_name,
                                         :query,
                                         :permission_key,
                                         :has_date_range,
                                         :start_date_default
  end
end