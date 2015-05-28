class PerformanceRanker

  def self.rank_sales(class_name)
    @total_count = 0
    for project in Project.all do
      ((Date.today - 1.month)..(Date.today)).each do |day|
        day_sales = query_sales class_name.downcase, project, day, day
        process_rankings day_sales, day, :day_rank, class_name
        week_sales = query_sales class_name.downcase, project, day.beginning_of_week, day
        process_rankings week_sales, day, :week_rank, class_name
        month_sales = query_sales class_name.downcase, project, day.beginning_of_month, day
        process_rankings month_sales, day, :month_rank, class_name
      end
    end
    ProcessLog.create process_class: "PerformanceRanker", records_processed: @total_count, notes: class_name
  end

  def self.query_sales(type, project, start_date, end_date)
    ActiveRecord::Base.connection.execute self.send("#{type}_query", project, start_date, end_date)
  end

  def self.person_query(project, start_date, end_date)
    %{
            SELECT

            day_sales_counts.saleable_id AS id,
            sum(day_sales_counts.sales) AS sales

            FROM day_sales_counts
            LEFT OUTER JOIN people
              ON people.id = day_sales_counts.saleable_id
            LEFT OUTER JOIN person_areas
              ON person_areas.person_id = people.id
            LEFT OUTER JOIN areas
              ON areas.id = person_areas.area_id
            LEFT OUTER JOIN projects
              ON projects.id = areas.project_id

            WHERE
              projects.id = #{project.id.to_s}
              AND day_sales_counts.saleable_type = 'Person'
              AND day_sales_counts.day >= CAST('#{start_date.strftime('%m/%d/%Y')}' AS DATE)
              AND day_sales_counts.day <= CAST('#{end_date.strftime('%m/%d/%Y')}' AS DATE)

            GROUP BY day_sales_counts.saleable_id
            ORDER BY sum(day_sales_counts.sales) DESC, day_sales_counts.saleable_id
    }
  end

  def self.area_query(project, start_date, end_date)
    %{
            SELECT

            day_sales_counts.saleable_id as id,
            sum(day_sales_counts.sales) AS sales

            FROM day_sales_counts
            LEFT OUTER JOIN areas
              ON areas.id = day_sales_counts.saleable_id
            LEFT OUTER JOIN projects
              ON projects.id = areas.project_id

            WHERE
              projects.id = #{project.id.to_s}
              AND day_sales_counts.saleable_type = 'Area'
              AND day_sales_counts.day >= CAST('#{start_date.strftime('%m/%d/%Y')}' AS DATE)
              AND day_sales_counts.day <= CAST('#{end_date.strftime('%m/%d/%Y')}' AS DATE)

            GROUP BY day_sales_counts.saleable_id
            ORDER BY sum(day_sales_counts.sales) DESC, day_sales_counts.saleable_id
        }
  end

  def self.process_rankings(sales_counts, day, column, type)
    rank = 0
    sales = 0
    for sales_count in sales_counts do
      if sales_count['sales'].to_i != sales
        rank += 1
        sales = sales_count['sales'].to_i
      end
      ranking = SalesPerformanceRank.find_or_initialize_by day: day,
                                                           rankable_id: sales_count['id'].to_i,
                                                           rankable_type: type
      ranking[column] = rank
      @total_count += 1 if ranking.save
    end
  end
end