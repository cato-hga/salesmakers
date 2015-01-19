puts 'Importing person addresses...'

ActiveRecord::Base.establish_connection(:rbd_connect_production)

results = ActiveRecord::Base.connection.select_all "select

  u.ad_user_id,
  initcap(a.address1) as line_1,
  a.address2 as line_2,
  initcap(a.city) as city,
  r.name as state,
  a.postal as zip

  from ad_user u
  left outer join c_bpartner bp
    on bp.c_bpartner_id = u.c_bpartner_id
  left outer join c_bpartner_location l
    on l.c_bpartner_id = bp.c_bpartner_id
  left outer join c_location a
    on a.c_location_id = l.c_location_id
  left outer join c_region r
    on r.c_region_id = a.c_region_id

  where
    r.c_region_id is not null"

ActiveRecord::Base.establish_connection(Rails.env)

puts 'Got ' + results.count.to_s + ' addresses...'

counter = 0
invalid_counter = 0
results.each do |row|
  counter += 1
  puts counter.to_s + ' addresses processed...' if counter % 50 == 0
  person = Person.find_by connect_user_id: row['ad_user_id']
  next unless person
  person.person_addresses.where(physical: true).destroy_all
  address = PersonAddress.new person: person,
                       line_1: row['line_1'],
                       line_2: row['line_2'],
                       city: row['city'],
                       state: row['state'],
                       zip: row['zip']
  invalid_counter += 1 unless address.save
end

puts invalid_counter.to_s + ' addresses were invalid and were not saved.'