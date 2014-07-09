puts "Creating projects..."

vonage = Client.find_by_name 'Vonage'
rbh = Client.find_by_name 'Retail Business Holdings'
sprint = Client.find_by_name 'Sprint'


vonage_retail = Project.create name: 'Vonage Retail',
                               client: vonage
vonage_events = Project.create name: 'Vonage Events',
                               client: vonage
corporate = Project.create name: 'RBD Corporate',
                           client: rbh
sprint_retail = Project.create name: 'Sprint Retail',
                           client: sprint

vrr = AreaType.create name: 'Vonage Retail Region',
                      project: vonage_retail
vrm = AreaType.create name: 'Vonage Retail Market',
                      project: vonage_retail
vrt = AreaType.create name: 'Vonage Retail Territory',
                      project: vonage_retail
ver = AreaType.create name: 'Vonage Event Region',
                      project: vonage_events
vet = AreaType.create name: 'Vonage Event Team',
                      project: vonage_events

co = AreaType.create name: 'Corporate Office',
                     project: corporate
cd = AreaType.create name: 'Corporate Department',
                     project: corporate
ct = AreaType.create name: 'Corporate Team',
                     project: corporate

srr = AreaType.create name: 'Sprint Retail Region',
                      project: sprint_retail
srt = AreaType.create name: 'Sprint Retail Territory',
                      project: sprint_retail

vr_connect = ConnectRegion.find_by_value 'Vonage Retail-1'
vrrs_connect = vr_connect.children
vrrs_connect.each do |vrr_connect|
  new_vrr = Area.create name: vrr_connect.name,
                        area_type: vrr,
                        project: vonage_retail,
                        created_at: vrr_connect.created,
                        updated_at: vrr_connect.updated
  vrms_connect = vrr_connect.children
  vrms_connect.each do |vrm_connect|
    new_vrm = Area.create name: vrm_connect.name,
                          area_type: vrm,
                          project: vonage_retail,
                          parent: new_vrr,
                          created_at: vrm_connect.created,
                          updated_at: vrm_connect.updated
    vrts_connect = vrm_connect.children
    vrts_connect.each do |vrt_connect|
      new_vrt = Area.create name: vrt_connect.name.gsub('Vonage Retail - ', ''),
                            area_type: vrt,
                            project: vonage_retail,
                            parent: new_vrm,
                            created_at: vrt_connect.created,
                            updated_at: vrt_connect.updated
    end
  end
end

ve_connect = ConnectRegion.find_by_value 'Vonage Events-1'
vers_connect = ve_connect.children
vers_connect.each do |ver_connect|
  new_ver = Area.create name: ver_connect.name,
                        area_type: ver,
                        project: vonage_events,
                        created_at: ver_connect.created,
                        updated_at: ver_connect.updated
  vems_connect = ver_connect.children
  vems_connect.each do |vem_connect|
    vets_connect = vem_connect.children
    vets_connect.each do |vet_connect|
      new_vet = Area.create name: vet_connect.name.gsub('Vonage Events - ', ''),
                            area_type: vet,
                            project: vonage_events,
                            parent: new_ver,
                            created_at: vet_connect.created,
                            updated_at: vet_connect.updated
    end
  end
end

#TODO Add Corporate trees

sr_connect = ConnectRegion.find_by_value 'Sprint-1'
srrs_connect = sr_connect.children
srrs_connect.each do |srr_connect|
  new_srr = Area.create name: srr_connect.name,
                        area_type: srr,
                        project: sprint_retail,
                        created_at: srr_connect.created,
                        updated_at: srr_connect.updated
  srms_connect = srr_connect.children
  srms_connect.each do |srm_connect|
    srts_connect = srm_connect.children
    srts_connect.each do |srt_connect|
      new_srt = Area.create name: srt_connect.name.gsub('Sprint - ', ''),
                            area_type: srt,
                            project: sprint_retail,
                            parent: new_srr,
                            created_at: srt_connect.created,
                            updated_at: srt_connect.updated
    end
  end
end
