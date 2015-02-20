class PerformanceRanker

  def self.rank_people_sales
    for project in Project.all do
      ((Date.today - 1.month)..(Date.today)).each do |day|
        day_people_sales = query_people_sales(project, day, day)
        process_rankings day_people_sales, day, :day_rank, 'Person'
        week_people_sales = query_people_sales(project, day.beginning_of_week, day)
        process_rankings week_people_sales, day, :week_rank, 'Person'
        month_people_sales = query_people_sales(project, day.beginning_of_month, day)
        process_rankings month_people_sales, day, :month_rank, 'Person'
      end
    end
  end

  def self.query_people_sales(project, start_date, end_date)
    ActiveRecord::Base.connection.execute %{
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

  def self.rank_areas_sales
    for project in Project.all do
      ((Date.today - 1.month)..(Date.today)).each do |day|
        day_areas_sales = query_area_sales(project, day, day)
        process_rankings day_areas_sales, day, :day_rank, 'Area'
        week_areas_sales = query_area_sales(project, day.beginning_of_week, day)
        process_rankings week_areas_sales, day, :week_rank, 'Area'
        month_areas_sales = query_area_sales(project, day.beginning_of_month, day)
        process_rankings month_areas_sales, day, :month_rank, 'Area'
      end
    end
  end

  def self.query_area_sales(project, start_date, end_date)
    ActiveRecord::Base.connection.execute %{
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
            ORDER BY sum(day_sales_counts.sales) DESC, day_sales_counts.saleable_id"
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
      ranking.save
    end
  end
end