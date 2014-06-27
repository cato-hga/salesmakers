administrator_position = Position.find_by_name 'System Administrator'
senior_software_developer = Position.find_by_name 'Senior Software Developer'

Person.create first_name: 'System',
              last_name: 'Administrator',
              display_name: 'System Administrator',
              email: 'retailingw@retaildoneright.com',
              personal_email: 'retailingw@retaildoneright.com',
              position_id: administrator_position.id,
              connect_user_id: '2C908AA22CBD1292012CBD1735100034',
              mobile_phone: '8005551212'

Person.create first_name: 'Anthony',
              last_name: 'Atkinson',
              display_name: 'Anthony Atkinson',
              email: 'aatkinson@retaildoneright.com',
              personal_email: 'develop.blaise@gmail.com',
              position_id: senior_software_developer.id,
              connect_user_id: '337EB300331F4762A4200CDE357E79E6',
              mobile_phone: '8635214572'

Person.create first_name: 'Stephen',
              last_name: 'Miles',
              display_name: 'Stephen Miles',
              email: 'smiles@retaildoneright.com',
              personal_email: 'milessa42@gmail.com',
              position_id: senior_software_developer.id,
              connect_user_id: '0AA3EE8FCDCF402ABCEB6280D1FC4C8D',
              mobile_phone: '8137164150'