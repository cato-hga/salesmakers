class CreateSalesPerformanceRanks < ActiveRecord::Migration
  def change
    create_table :sales_performance_ranks do |t|
      t.date :day, null: false
      t.references :rankable, polymorphic: true, null: false
      t.integer :day_rank
      t.integer :week_rank
      t.integer :month_rank
      t.integer :year_rank

      t.timestamps
    end
  end
end
