puts 'Importing Supervisors...'

people = ConnectUser.active
for connect_user in people do
  supervisor = Person.find_by_connect_user_id connect_user.supervisor_id
  next if not supervisor
  person = Person.find_by_connect_user_id connect_user.id
  next if not person
  person.supervisor = supervisor
  person.save
end