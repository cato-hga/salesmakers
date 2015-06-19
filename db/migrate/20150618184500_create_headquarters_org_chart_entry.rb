class CreateHeadquartersOrgChartEntry < ActiveRecord::Migration
  def up
    execute "
            create or replace view headquarters_org_chart_entries as
            select

            row_number() over(order by dep.name, p.display_name) as id,
            dep.name as department_name,
            dep.id as department_id,
            pos.name as position_name,
            pos.id as position_id,
            p.display_name as person_name,
            p.id as person_id

            from departments dep
            left outer join positions pos
              on pos.department_id = dep.id
            left outer join people p
              on p.position_id = pos.id

            where
              p.active = true
              and pos.hq = true

            order by department_name, person_name"
  end

  def down
    execute "drop view headquarters_org_chart_entries"
  end
end
