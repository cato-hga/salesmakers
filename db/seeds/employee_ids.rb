puts 'Importing Employee IDs...'

ids = ConnectUserMapping.employee_ids
for eid in ids do
  person = Person.find_by_connect_user_id eid.ad_user_id
  next if not person
  person.eid = eid.mapping.to_i
  person.save
end