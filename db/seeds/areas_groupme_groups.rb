puts "Updating Areas' GroupMe group numbers..."
vr = Project.find_by name: 'Vonage'
ve = Project.find_by name: 'Vonage Events'
sr = Project.find_by name: 'Sprint Retail'

area = Area.find_by(name: 'New Orleans Territory', project_id: sr.id)
area.update(groupme_group: '9641550') if area
area = Area.find_by(name: 'San Antonio Territory', project_id: sr.id)
area.update(groupme_group: '9642315') if area
area = Area.find_by(name: 'Atlanta Territory', project_id: sr.id)
area.update(groupme_group: '11016393') if area
area = Area.find_by(name: 'Oklahoma City Territory', project_id: sr.id)
area.update(groupme_group: '11179805') if area
area = Area.find_by(name: 'Nashville Territory', project_id: sr.id)
area.update(groupme_group: '9043075') if area
area = Area.find_by(name: 'Milwaukee Territory', project_id: sr.id)
area.update(groupme_group: '9631841') if area
area = Area.find_by(name: 'Charlotte Territory', project_id: sr.id)
area.update(groupme_group: '11548013') if area
area = Area.find_by(name: 'Tulsa Territory', project_id: sr.id)
area.update(groupme_group: '11179820') if area
area = Area.find_by(name: 'Chicago Territory', project_id: sr.id)
area.update(groupme_group: '9860453') if area
area = Area.find_by(name: 'Baltimore/Washington Territory', project_id: sr.id)
area.update(groupme_group: '9374507') if area
area = Area.find_by(name: 'Raleigh Territory', project_id: sr.id)
area.update(groupme_group: '11548005') if area
area = Area.find_by(name: 'Austin Territory', project_id: sr.id)
area.update(groupme_group: '11548040') if area
area = Area.find_by(name: 'Houston Territory', project_id: sr.id)
area.update(groupme_group: '10387940') if area
area = Area.find_by(name: 'Baton Rouge Territory', project_id: sr.id)
area.update(groupme_group: '9641550') if area
area = Area.find_by(name: 'Greensboro Territory', project_id: sr.id)
area.update(groupme_group: '10226285') if area
area = Area.find_by(name: 'Tampa Territory', project_id: sr.id)
area.update(groupme_group: '9595923') if area
area = Area.find_by(name: 'St. Louis Territory', project_id: sr.id)
area.update(groupme_group: '9310910') if area
area = Area.find_by(name: 'Phoenix Territory', project_id: sr.id)
area.update(groupme_group: '9629996') if area
area = Area.find_by(name: 'Orlando Territory', project_id: sr.id)
area.update(groupme_group: '7379335') if area
area = Area.find_by(name: 'Miami Territory', project_id: sr.id)
area.update(groupme_group: '9491650') if area
area = Area.find_by(name: 'Boston Territory', project_id: sr.id)
area.update(groupme_group: '9490853') if area
area = Area.find_by(name: 'Los Angeles Territory', project_id: sr.id)
area.update(groupme_group: '8241397') if area
area = Area.find_by(name: 'Memphis Territory', project_id: sr.id)
area.update(groupme_group: '9762032') if area
area = Area.find_by(name: 'Indianapolis Territory', project_id: sr.id)
area.update(groupme_group: '9729101') if area
area = Area.find_by(name: 'San Diego Territory', project_id: sr.id)
area.update(groupme_group: '9363793') if area
area = Area.find_by(name: 'Kansas City Territory', project_id: sr.id)
area.update(groupme_group: '9043666') if area
area = Area.find_by(name: 'Dallas/Fort Worth Territory', project_id: sr.id)
area.update(groupme_group: '9203440') if area
area = Area.find_by(name: 'Sprint White Region', project_id: sr.id)
area.update(groupme_group: '9877513') if area
area = Area.find_by(name: 'Minneapolis Territory', project_id: sr.id)
area.update(groupme_group: '10452252') if area
area = Area.find_by(name: 'Philadelphia Territory', project_id: sr.id)
area.update(groupme_group: '9490923') if area
area = Area.find_by(name: 'Norfolk Territory', project_id: sr.id)
area.update(groupme_group: '9699498') if area

area = Area.find_by(name: 'Houston South Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Vonage Retail - Vonage Owned Retail', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'DMV Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'MVP Events Region', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Northeast Events Region', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Edison Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Manhattan Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Queens Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'West Events Region', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Denver Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Pueblo Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Las Vegas Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Portland Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Seattle Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: ' Seattle North Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Southwest Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Albuquerque Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Austin Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Corpus Christi Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Houston Northeast Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Houston Northwest Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Lubbock Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'San Antonio Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'New York/New Jersey Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Brooklyn Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'North New Jersey Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Denver Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Las Vegas Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Portland Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: ' Seattle South Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Amarillo Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'El Paso Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Philadelphia Events Market', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Columbia Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Philadelphia Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area
area = Area.find_by(name: 'Virginia North Event Team', project_id: ve.id)
area.update(groupme_group: '10577924') if area

area = Area.find_by(name: 'Virginia Territory', project_id: vr.id)
area.update(groupme_group: '10580456') if area
area = Area.find_by(name: 'Central California Territory', project_id: vr.id)
area.update(groupme_group: '6326419') if area
area = Area.find_by(name: 'Sacramento South Territory', project_id: vr.id)
area.update(groupme_group: '4734485') if area
area = Area.find_by(name: 'Las Vegas Territory', project_id: vr.id)
area.update(groupme_group: '9980187') if area
area = Area.find_by(name: 'Phoenix West Territory', project_id: vr.id)
area.update(groupme_group: '10799631') if area
area = Area.find_by(name: 'Seattle West Territory', project_id: vr.id)
area.update(groupme_group: '5178392') if area
area = Area.find_by(name: 'Seattle East Territory', project_id: vr.id)
area.update(groupme_group: '9827585') if area
area = Area.find_by(name: 'El Paso Territory', project_id: vr.id)
area.update(groupme_group: '11271436') if area
area = Area.find_by(name: 'Sacramento North Territory', project_id: vr.id)
area.update(groupme_group: '3789302') if area
area = Area.find_by(name: 'Portland Territory', project_id: vr.id)
area.update(groupme_group: '5928985') if area
area = Area.find_by(name: 'Southbay Territory', project_id: vr.id)
area.update(groupme_group: '9429767') if area
area = Area.find_by(name: 'Reno Territory', project_id: vr.id)
area.update(groupme_group: '10592347') if area
area = Area.find_by(name: 'Orange County Territory', project_id: vr.id)
area.update(groupme_group: '9808673') if area
area = Area.find_by(name: 'Detroit South Territory', project_id: vr.id)
area.update(groupme_group: '10728579') if area
area = Area.find_by(name: 'Visalia Territory', project_id: vr.id)
area.update(groupme_group: '10889222') if area
area = Area.find_by(name: 'Austin Territory', project_id: vr.id)
area.update(groupme_group: '9612365') if area
area = Area.find_by(name: 'Houston East Territory', project_id: vr.id)
area.update(groupme_group: '8955025') if area
area = Area.find_by(name: 'Houston West Territory', project_id: vr.id)
area.update(groupme_group: '8895922') if area
area = Area.find_by(name: 'Miami Territory', project_id: vr.id)
area.update(groupme_group: '9745703') if area
area = Area.find_by(name: 'Orlando Territory', project_id: vr.id)
area.update(groupme_group: '8170781') if area
area = Area.find_by(name: 'Milwaukee Territory', project_id: vr.id)
area.update(groupme_group: '5769019') if area
area = Area.find_by(name: 'St. Louis East Territory', project_id: vr.id)
area.update(groupme_group: '7638971') if area
area = Area.find_by(name: 'Dallas Southwest Territory', project_id: vr.id)
area.update(groupme_group: '4445472') if area
area = Area.find_by(name: 'Modesto Territory', project_id: vr.id)
area.update(groupme_group: '9768664') if area
area = Area.find_by(name: 'Eastbay Territory', project_id: vr.id)
area.update(groupme_group: '6159944') if area
area = Area.find_by(name: 'Raleigh Territory', project_id: vr.id)
area.update(groupme_group: '11057130') if area
area = Area.find_by(name: 'Greensboro Territory', project_id: vr.id)
area.update(groupme_group: '6326419') if area
area = Area.find_by(name: 'Atlanta West Territory', project_id: vr.id)
area.update(groupme_group: '10045308') if area
area = Area.find_by(name: 'Houston North Territory', project_id: vr.id)
area.update(groupme_group: '10916566') if area
area = Area.find_by(name: 'Detroit East Territory', project_id: vr.id)
area.update(groupme_group: '6403418') if area
area = Area.find_by(name: 'St. Louis West Territory', project_id: vr.id)
area.update(groupme_group: '3518936') if area
area = Area.find_by(name: 'Chicago South Territory', project_id: vr.id)
area.update(groupme_group: '9280696') if area
area = Area.find_by(name: 'Detroit West Territory', project_id: vr.id)
area.update(groupme_group: '3945967') if area
area = Area.find_by(name: 'Atlanta South Territory', project_id: vr.id)
area.update(groupme_group: '8712767') if area
area = Area.find_by(name: 'GA/NC Retail Market', project_id: vr.id)
area.update(groupme_group: '7117190') if area
area = Area.find_by(name: 'New Jersey Central Territory', project_id: vr.id)
area.update(groupme_group: '6636981') if area
area = Area.find_by(name: 'San Gabriel Valley Territory', project_id: vr.id)
area.update(groupme_group: '11140838') if area
area = Area.find_by(name: 'Maryland Territory', project_id: vr.id)
area.update(groupme_group: '10597192') if area
area = Area.find_by(name: 'Irving Territory', project_id: vr.id)
area.update(groupme_group: '4445472') if area
area = Area.find_by(name: 'Philadelphia Territory', project_id: vr.id)
area.update(groupme_group: '8751688') if area
area = Area.find_by(name: 'Dallas North Territory', project_id: vr.id)
area.update(groupme_group: '10560562') if area
area = Area.find_by(name: 'Denver Territory', project_id: vr.id)
area.update(groupme_group: '4445472') if area
area = Area.find_by(name: 'Charlotte Territory', project_id: vr.id)
area.update(groupme_group: '10315961') if area
area = Area.find_by(name: 'Atlanta East Territory', project_id: vr.id)
area.update(groupme_group: '9725549') if area
area = Area.find_by(name: 'Ft. Lauderdale Territory', project_id: vr.id)
area.update(groupme_group: '9745734') if area
area = Area.find_by(name: 'Chicago North Territory', project_id: vr.id)
area.update(groupme_group: '3632051') if area
area = Area.find_by(name: 'San Fernando Territory', project_id: vr.id)
area.update(groupme_group: '4009063') if area
area = Area.find_by(name: 'San Diego Territory', project_id: vr.id)
area.update(groupme_group: '10019946') if area
area = Area.find_by(name: 'Los Angeles Territory', project_id: vr.id)
area.update(groupme_group: '7128198') if area
area = Area.find_by(name: 'Inland Empire Territory', project_id: vr.id)
area.update(groupme_group: '5534929') if area
area = Area.find_by(name: 'Phoenix North Territory', project_id: vr.id)
area.update(groupme_group: '6557571') if area
area = Area.find_by(name: 'Mesa Territory', project_id: vr.id)
area.update(groupme_group: '8363397') if area
area = Area.find_by(name: 'New Jersey North Territory', project_id: vr.id)
area.update(groupme_group: '5016832') if area