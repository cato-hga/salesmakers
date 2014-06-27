importable_people = ConnectUser.active.not_main_administrators.load

puts "Importing " + importable_people.count.to_s + " people... "

people_counter = 0
importable_people.each do |person|
  people_counter = people_counter + 1
  puts "   - " + people_counter.to_s + " people imported..." unless people_counter % 25 > 0
  person = Person.return_from_connect_user person
  person.create_supervisor
end