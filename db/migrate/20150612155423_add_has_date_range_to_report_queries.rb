class AddHasDateRangeToReportQueries < ActiveRecord::Migration
  def change
    add_column :report_queries, :has_date_range, :boolean, null: false, default: false
  end
end
