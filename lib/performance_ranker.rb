class PerformanceRanker

  def self.rank_people_sales
    for project in Project.all do
      ((Date.today - 1.month)..(Date.today)).each do |day|
        day_people_sales = day_sales_counts project, day, 'Person'
        process_day_rankings day_people_sales, day
        week_people_sales_sql = "SELECT

            day_sales_counts.saleable_id as id,
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
              projects.id = " + project.id.to_s + "
              AND day_sales_counts.saleable_type = 'Person'
              AND day_sales_counts.day >= CAST('" +
                  day.beginning_of_week.strftime('%m/%d/%Y') + "' AS DATE)
              AND day_sales_counts.day <= CAST('" +
                  day.strftime('%m/%d/%Y') + "' AS DATE)

            GROUP BY day_sales_counts.saleable_id
            ORDER BY sum(day_sales_counts.sales) DESC, day_sales_counts.saleable_id"
        week_people_sales = ActiveRecord::Base.connection.execute(week_people_sales_sql)
        process_week_people_rankings week_people_sales, day, 'Person'
        month_people_sales_sql = "SELECT

            day_sales_counts.saleable_id as id,
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
              projects.id = " + project.id.to_s + "
              AND day_sales_counts.saleable_type = 'Person'
              AND day_sales_counts.day >= CAST('" +
            day.beginning_of_month.strftime('%m/%d/%Y') + "' AS DATE)
              AND day_sales_counts.day <= CAST('" +
            day.strftime('%m/%d/%Y') + "' AS DATE)

            GROUP BY day_sales_counts.saleable_id
            ORDER BY sum(day_sales_counts.sales) DESC, day_sales_counts.saleable_id"
        month_people_sales = ActiveRecord::Base.connection.execute(month_people_sales_sql)
        process_month_rankings month_people_sales, day, 'Person'
      end
    end
  end

  def self.rank_areas_sales
    for project in Project.all do
      ((Date.today - 1.month)..(Date.today)).each do |day|
        day_areas_sales = day_sales_counts project, day, 'Area'
        process_day_rankings day_areas_sales, day
        week_areas_sales_sql = "SELECT

            day_sales_counts.saleable_id as id,
            sum(day_sales_counts.sales) AS sales

            FROM day_sales_counts
            LEFT OUTER JOIN areas
              ON areas.id = day_sales_counts.saleable_id
            LEFT OUTER JOIN projects
              ON projects.id = areas.project_id

            WHERE
              projects.id = " + project.id.to_s + "
              AND day_sales_counts.saleable_type = 'Area'
              AND day_sales_counts.day >= CAST('" +
            day.beginning_of_week.strftime('%m/%d/%Y') + "' AS DATE)
              AND day_sales_counts.day <= CAST('" +
            day.strftime('%m/%d/%Y') + "' AS DATE)

            GROUP BY day_sales_counts.saleable_id
            ORDER BY sum(day_sales_counts.sales) DESC, day_sales_counts.saleable_id"
        week_areas_sales = ActiveRecord::Base.connection.execute(week_areas_sales_sql)
        process_week_rankings week_areas_sales, day, 'Area'
        month_areas_sales_sql = "SELECT

            day_sales_counts.saleable_id as id,
            sum(day_sales_counts.sales) AS sales

            FROM day_sales_counts
            LEFT OUTER JOIN areas
              ON areas.id = day_sales_counts.saleable_id
            LEFT OUTER JOIN projects
              ON projects.id = areas.project_id

            WHERE
              projects.id = " + project.id.to_s + "
              AND day_sales_counts.saleable_type = 'Area'
              AND day_sales_counts.day >= CAST('" +
            day.beginning_of_month.strftime('%m/%d/%Y') + "' AS DATE)
              AND day_sales_counts.day <= CAST('" +
            day.strftime('%m/%d/%Y') + "' AS DATE)

            GROUP BY day_sales_counts.saleable_id
            ORDER BY sum(day_sales_counts.sales) DESC, day_sales_counts.saleable_id"
        month_areas_sales = ActiveRecord::Base.connection.execute(month_areas_sales_sql)
        process_month_rankings month_areas_sales, day, 'Area'
      end
    end
  end

  def self.day_sales_counts(project, day, type)
    DaySalesCount.find_by_sql("
            SELECT

            day_sales_counts.*

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
              projects.id = " + project.id.to_s + "
              AND day_sales_counts.saleable_type = '" + type + "'
              AND day_sales_counts.day = CAST('" +
                                  day.strftime('%m/%d/%Y') + "' AS DATE)

            ORDER BY day_sales_counts.sales DESC")
  end

  def self.process_day_rankings(day_sales_counts, day)
    rank = 0
    sales = 0
    for day_sales in day_sales_counts do
      if day_sales.sales != sales
        rank += 1
        sales = day_sales.sales
      end
      ranking = SalesPerformanceRank.find_or_initialize_by day: day,
                                                           rankable: day_sales.saleable
      ranking.day_rank = rank
      ranking.save
    end
  end

  def self.process_week_rankings(week_sales_counts, day, type)
    rank = 0
    sales = 0
    for week_sales in week_sales_counts do
      if week_sales['sales'].to_i != sales
        rank += 1
        sales = week_sales['sales'].to_i
      end
      ranking = SalesPerformanceRank.find_or_initialize_by day: day,
                                                           rankable_id: week_sales['id'].to_i,
                                                           rankable_type: type
      ranking.week_rank = rank
      ranking.save
    end
  end

  def self.process_month_rankings(month_sales_counts, day, type)
    rank = 0
    sales = 0
    for month_sales in month_sales_counts do
      if month_sales['sales'].to_i != sales
        rank += 1
        sales = month_sales['sales'].to_i
      end
      ranking = SalesPerformanceRank.find_or_initialize_by day: day,
                                                           rankable_id: month_sales['id'].to_i,
                                                           rankable_type: type
      ranking.month_rank = rank
      ranking.save
    end
  end

end