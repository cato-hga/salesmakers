class ReportQueriesController < ApplicationController
  after_action :verify_authorized, except: [:index]

  def index
    @report_queries = policy_scope(ReportQuery).all
  end

  def show
    @report_query = ReportQuery.find params[:id]
    authorize @report_query
    @results = ActiveRecord::Base.connection.execute @report_query.query
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

  private

  def report_query_params
    params.require(:report_query).permit :name,
                                         :category_name,
                                         :database_name,
                                         :query,
                                         :permission_key
  end
end