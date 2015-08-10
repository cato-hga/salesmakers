puts 'Importing employment records...'

people = Person.all
for person in people do
  person.import_employment_from_connect
end