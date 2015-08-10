class AddStartDateDefaultToReportQueries < ActiveRecord::Migration
  def change
    add_column :report_queries, :start_date_default, :string
  end
end
