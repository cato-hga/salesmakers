class CreateReportQueries < ActiveRecord::Migration
  def change
    create_table :report_queries do |t|
      t.string :name, null: false
      t.string :category_name, null: false
      t.string :database_name, null: false
      t.text :query, null: false
      t.string :permission_key, null: false

      t.timestamps null: false
    end
  end
end
