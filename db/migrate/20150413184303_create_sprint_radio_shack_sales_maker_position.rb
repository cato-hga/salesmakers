class CreateSprintRadioShackSalesMakerPosition < ActiveRecord::Migration
  def change

    department = Department.create name: 'Sprint RadioShack Sales', corporate: false
    sprint_salesmaker = Position.create name: 'Sprint RadioShack SalesMaker',
                                        department: department,
                                        field: true,
                                        leadership: false,
                                        all_field_visibility: false,
                                        all_corporate_visibility: false

    people_array = Person.where("id in (select
          p.id

          from people p
          left outer join person_areas pa
            on p.id = pa.person_id
          left outer join areas a
            on pa.area_id = a.id

          where a.project_id = 6
              and p.email ilike '%@srs%')")
    for person in people_array
      person.update position: sprint_salesmaker
    end
  end
end
