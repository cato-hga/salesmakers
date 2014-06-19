administrator_position = Position.find_by_name 'System Administrator'
senior_software_developer = Position.find_by_name 'Senior Software Developer'

User.create first_name: 'System',
            last_name: 'Administrator',
            display_name: 'System Administrator',
            email: 'retailingw@retaildoneright.com',
            personal_email: 'retailingw@retaildoneright.com',
            position_id: administrator_position.id,
            connect_user_id: '2C908AA22CBD1292012CBD1735100034'

User.create first_name: 'Anthony',
            last_name: 'Atkinson',
            display_name: 'Anthony Atkinson',
            email: 'aatkinson@retaildoneright.com',
            personal_email: 'develop.blaise@gmail.com',
            position_id: senior_software_developer.id,
            connect_user_id: '337EB300331F4762A4200CDE357E79E6'

User.create first_name: 'Stephen',
            last_name: 'Miles',
            display_name: 'Stephen Miles',
            email: 'smiles@retaildoneright.com',
            personal_email: 'milessa42@gmail.com',
            #TODO Upate the next two lines
            position_id: senior_software_developer.id,
            connect_user_id: '337EB300331F4762A4200CDE357E79E6'