module SprintSales::ScoreboardQuery
  def query
    @show_locations = @depth && @depth == 5 ? true : false
    @show_bottom_level = @depth && @depth >= 5 ? true : false
    @show_territories = @depth && @depth >= 4 ? true : false
    @show_markets = @depth && @depth >= 3 ? true : false
    %{
      select

      c.name as client,
      proj.name as project,
      case when rt.name not like '%Region' then null else r.name end as region,
      #{get_market_level(@show_markets)}
      #{get_territory_level(@show_territories)}
      #{get_bottom_level(@show_bottom_level, @show_locations)}
      sum(sales) as sales,
      sum(activations) as activations,
      sum(new_accounts) as new_accounts

      from day_sales_counts dsc
      #{get_bottom_level_joins(@show_bottom_level, @show_locations)}
      #{get_territory_joins(@show_bottom_level, @show_territories)}
      #{get_market_and_region_joins(@show_territories, @show_markets)}

      left outer join area_types rt
        on rt.id = r.area_type_id
      left outer join projects proj
        on proj.id = r.project_id
      left outer join clients c
        on c.id = proj.client_id

      where
        c.name = '#{@client.name}'
        and dsc.day >= cast('#{@range.first.strftime('%m/%d/%Y')}' as date)
        and dsc.day <= cast('#{@range.last.strftime('%m/%d/%Y')}' as date)
        #{get_project_where_clause}
        #{get_saleable_type_where_clause}
        #{get_area_where_clause}

      group by
        c.name,
        proj.name,
        r.name,
        rt.name,
        #{get_markets_grouping_and_ordering(@show_territories, @show_markets)}
        #{get_territories_grouping_and_ordering(@show_bottom_level, @show_territories)}
        #{get_bottom_level_grouping_and_ordering(@show_bottom_level, @show_locations)}

      order by
        c.name,
        proj.name,
        r.name,
        rt.name,
        #{get_markets_grouping_and_ordering(@show_territories, @show_markets)}
        #{get_territories_grouping_and_ordering(@show_bottom_level, @show_territories)}
        #{get_bottom_level_grouping_and_ordering(@show_bottom_level, @show_locations)}
    }
  end

  private

  def get_bottom_level(show_bottom_level, show_locations)
    return unless show_bottom_level
    if show_locations
      %{
        ch.name || ', ' || l.city || ', ' || l.display_name as bottom_level,
        l.id as bottom_level_id,
      }
    else
      %{
        initcap(p.display_name) as bottom_level,
        p.id as bottom_level_id,
      }
    end
  end

  def get_bottom_level_joins(show_bottom_level, show_locations)
    return unless show_bottom_level
    if show_locations
      %{
        left outer join location_areas la
        on la.id = dsc.saleable_id
        left outer join locations l
        on l.id = la.location_id
        left outer join channels ch
        on ch.id = l.channel_id
      }
    else
      %{
        left outer join people p
        on p.id = dsc.saleable_id
        left outer join person_areas la
        on la.person_id = p.id
      }
    end
  end

  def get_territory_level(show_territories)
    if show_territories
      " case when tt.name not like '%Territory' then null else t.name end as territory, "
    else
      nil
    end
  end

  def get_market_level(show_markets)
    if show_markets
      %{
        case when mt.name not like '%Market' then null else m.name end as market,
        case when mt.name not like '%Market' then null else initcap(sd.display_name) end as market_sd,
        case when mt.name not like '%Market' then null else sd.id end as market_sd_id,
      }
    else
      nil
    end
  end

  def get_territory_joins(show_bottom_level, show_territories)
    return unless show_territories
    if show_bottom_level
      %{
        left outer join areas t
          on t.id = la.area_id
        left outer join area_types tt
          on tt.id = t.area_type_id
      }
    else
      %{
        left outer join areas t
          on t.id = dsc.saleable_id
        left outer join area_types tt
          on tt.id = t.area_type_id
      }
    end
  end

  def get_market_and_region_joins(show_territories, show_markets)
    return unless show_markets
    if show_territories
      %{
        left outer join areas m
          on m.id = case when t.ancestry like '%/%' then cast(split_part(t.ancestry, '/', 2) as integer) else cast(t.ancestry as integer) end
        left outer join person_areas sds
          on sds.area_id = m.id
          and sds.manages = true
        left outer join people sd
          on sd.id = sds.person_id
        left outer join area_types mt
          on mt.id = m.area_type_id
        left outer join areas r
          on r.id = case when m.ancestry like '%/%' then cast(split_part(m.ancestry, '/', 2) as integer) else cast(split_part(t.ancestry, '/', 1) as integer) end
      }
    else
      %{
        left outer join areas m
          on m.id = dsc.saleable_id
        left outer join person_areas sds
          on sds.area_id = m.id
          and sds.manages = true
        left outer join people sd
          on sd.id = sds.person_id
        left outer join area_types mt
          on mt.id = m.area_type_id
        left outer join areas r
        on r.id = case when m.ancestry like '%/%' then cast(split_part(m.ancestry, '/', 2) as integer) else cast(m.ancestry as integer) end
      }
    end
  end

  def get_bottom_level_grouping_and_ordering(show_bottom_level, show_locations)
    return unless show_bottom_level
    if show_locations
      %{
        ch.name,
        ch.id,
        l.city,
        l.display_name,
        l.id
      }
    else
      %{
        p.display_name,
        p.id
      }
    end
  end

  def get_territories_grouping_and_ordering(show_bottom_level, show_territories)
    if show_territories
      " t.name, tt.name" + (show_bottom_level ? ", " : " ")
    else
      nil
    end
  end

  def get_markets_grouping_and_ordering(show_territories, show_markets)
    if show_markets
      " m.name, mt.name, sd.display_name, sd.id" + (show_territories ? ", " : " ")
    end
  end

  def get_project_where_clause
    if @project
      %{
        and proj.name = '#{@project.name}'
      }
    end
  end

  def get_saleable_type_where_clause
    case @depth
      when 6
        " and dsc.saleable_type = 'Person' "
      when 5
        " and dsc.saleable_type = 'LocationArea' "
      when 4
        " and dsc.saleable_type = 'Area' "
      when 3
        " and dsc.saleable_type = 'Area' "
      when 2
        " and dsc.saleable_type = 'Area' "
      when 1
        " and dsc.saleable_type = 'Project' "
    end
  end

  def get_area_where_clause
    if @depth == 4
      " and tt.name LIKE '% Territory' "
    elsif @depth == 3
      " and mt.name LIKE '% Market'"
    end
  end
end