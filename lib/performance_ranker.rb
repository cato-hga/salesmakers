class PerformanceRanker

  def self.rank_sales class_name, automated = false, start_date = Date.today - 1.month, end_date = Date.today
    @total_count = 0
    for project in Project.all do
      if class_name == 'Area'
        for area_type in project.area_types do
          (start_date..end_date).each do |day|
            day_sales = query_sales class_name.downcase, project, day, day, area_type
            process_rankings day_sales, day, :day_rank, class_name
            week_sales = query_sales class_name.downcase, project, day.beginning_of_week, day, area_type
            process_rankings week_sales, day, :week_rank, class_name
            month_sales = query_sales class_name.downcase, project, day.beginning_of_month, day, area_type
            process_rankings month_sales, day, :month_rank, class_name
            year_sales = query_sales class_name.downcase, project, day.beginning_of_year, day, area_type
            process_rankings year_sales, day, :year_rank, class_name
          end
        end
      else
        (start_date..end_date).each do |day|
          day_sales = query_sales class_name.downcase, project, day, day
          process_rankings day_sales, day, :day_rank, class_name
          week_sales = query_sales class_name.downcase, project, day.beginning_of_week, day
          process_rankings week_sales, day, :week_rank, class_name
          month_sales = query_sales class_name.downcase, project, day.beginning_of_month, day
          process_rankings month_sales, day, :month_rank, class_name
          year_sales = query_sales class_name.downcase, project, day.beginning_of_year, day
          process_rankings year_sales, day, :year_rank, class_name
        end
      end
    end
    ProcessLog.create process_class: "PerformanceRanker",
                      records_processed: @total_count,
                      notes: class_name if automated
  end

  def self.query_sales(type, project, start_date, end_date, area_type = nil)
    ActiveRecord::Base.connection.execute self.send("#{type}_query", project, start_date, end_date, area_type)
  end

  def self.person_query(project, start_date, end_date, area_type = nil)
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

  def self.area_query(project, start_date, end_date, area_type = nil)
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
              AND areas.area_type_id = #{area_type.id}

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