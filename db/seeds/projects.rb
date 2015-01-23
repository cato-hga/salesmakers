puts "Creating projects..."

vonage = Client.find_by name: 'Vonage'
rbh = Client.find_by name: 'Retail Business Holdings'
sprint = Client.find_by name: 'Sprint'
comcast = Client.find_by name: 'Comcast'

vonage_retail = Project.find_or_create_by name: 'Vonage Retail',
                                          client: vonage
vonage_events = Project.find_or_create_by name: 'Vonage Events',
                                          client: vonage
headquarters = Project.find_or_create_by name: 'RBD Company HQ',
                                         client: rbh
sprint_retail = Project.find_or_create_by name: 'Sprint Retail',
                                          client: sprint
comcast_retail = Project.find_or_create_by name: 'Comcast Retail',
                                           client: comcast

vrr = AreaType.find_or_create_by name: 'Vonage Retail Region',
                                 project: vonage_retail
vrm = AreaType.find_or_create_by name: 'Vonage Retail Market',
                                 project: vonage_retail
vrt = AreaType.find_or_create_by name: 'Vonage Retail Territory',
                                 project: vonage_retail
ver = AreaType.find_or_create_by name: 'Vonage Event Region',
                                 project: vonage_events
vem = AreaType.find_or_create_by name: 'Vonage Event Market',
                                 project: vonage_events
vet = AreaType.find_or_create_by name: 'Vonage Event Team',
                                 project: vonage_events

hqo = AreaType.find_or_create_by name: 'Company HQ',
                                 project: headquarters
hqd = AreaType.find_or_create_by name: 'HQ Department',
                                 project: headquarters
hqt = AreaType.find_or_create_by name: 'HQ Team',
                                 project: headquarters

srr = AreaType.find_or_create_by name: 'Sprint Retail Region',
                                 project: sprint_retail
srt = AreaType.find_or_create_by name: 'Sprint Retail Territory',
                                 project: sprint_retail

ccrr = AreaType.find_or_create_by name: 'Comcast Retail Region',
                                  project: comcast_retail
ccrm = AreaType.find_or_create_by name: 'Comcast Retail Market',
                                  project: comcast_retail
ccrt = AreaType.find_or_create_by name: 'Comcast Retail Territory',
                                  project: comcast_retail

vr_connect = ConnectRegion.find_by_value 'Vonage Retail-1'
vrrs_connect = vr_connect.children
vrrs_connect.each do |vrr_connect|
  new_vrr = Area.find_or_create_by name: vrr_connect.name,
                                   area_type: vrr,
                                   project: vonage_retail,
                                   created_at: vrr_connect.created,
                                   updated_at: vrr_connect.updated
  vrms_connect = vrr_connect.children
  vrms_connect.each do |vrm_connect|
    new_vrm = Area.find_or_initialize_by name: vrm_connect.name,
                                         area_type: vrm,
                                         project: vonage_retail,
                                         created_at: vrm_connect.created,
                                         updated_at: vrm_connect.updated
    new_vrm.save; new_vrm.parent = new_vrr; new_vrm.save
    vrts_connect = vrm_connect.children
    vrts_connect.each do |vrt_connect|
      new_vrt = Area.find_or_initialize_by name: vrt_connect.name.gsub('Vonage Retail - ', ''),
                                           area_type: vrt,
                                           project: vonage_retail,
                                           created_at: vrt_connect.created,
                                           updated_at: vrt_connect.updated
      new_vrt.save; new_vrt.parent = new_vrm; new_vrt.save
    end
  end
end

ve_connect = ConnectRegion.find_by_value 'Vonage Events-1'
vers_connect = ve_connect.children
vers_connect.each do |ver_connect|
  new_ver = Area.find_or_create_by name: ver_connect.name,
                                   area_type: ver,
                                   project: vonage_events,
                                   created_at: ver_connect.created,
                                   updated_at: ver_connect.updated
  vems_connect = ver_connect.children
  vems_connect.each do |vem_connect|
    new_vem = Area.find_or_initialize_by name: vem_connect.name,
                                         area_type: vem,
                                         project: vonage_events,
                                         created_at: vem_connect.created,
                                         updated_at: vem_connect.updated
    new_vem.save; new_vem.parent = new_ver; new_vem.save
    vets_connect = vem_connect.children
    vets_connect.each do |vet_connect|
      new_vet = Area.find_or_initialize_by name: vet_connect.name.gsub('Vonage Events - ', ''),
                                           area_type: vet,
                                           project: vonage_events,
                                           created_at: vet_connect.created,
                                           updated_at: vet_connect.updated
      new_vet.save; new_vet.parent = new_vem; new_vet.save
    end
  end
end

#TODO Add  trees

sr_connect = ConnectRegion.find_by_value 'Sprint-1'
srrs_connect = sr_connect.children
srrs_connect.each do |srr_connect|
  new_srr = Area.find_or_create_by name: srr_connect.name,
                                   area_type: srr,
                                   project: sprint_retail,
                                   created_at: srr_connect.created,
                                   updated_at: srr_connect.updated
  srms_connect = srr_connect.children
  srms_connect.each do |srm_connect|
    srts_connect = srm_connect.children
    srts_connect.each do |srt_connect|
      new_srt = Area.find_or_initialize_by name: srt_connect.name.gsub('Sprint - ', ''),
                                           area_type: srt,
                                           project: sprint_retail,
                                           created_at: srt_connect.created,
                                           updated_at: srt_connect.updated
      new_srt.save; new_srt.parent = new_srr; new_srt.save
    end
  end
end

ccr_connect = ConnectRegion.find_by_value 'Comcast Retail-1'
ccrrs_connect = ccr_connect.children
ccrrs_connect.each do |ccrr_connect|
  new_ccrr = Area.find_or_create_by name: ccrr_connect.name,
                                    area_type: ccrr,
                                    project: comcast_retail,
                                    created_at: ccrr_connect.created,
                                    updated_at: ccrr_connect.updated
  ccrms_connect = ccrr_connect.children
  ccrms_connect.each do |ccrm_connect|
    new_ccrm = Area.find_or_initialize_by name: ccrm_connect.name,
                                          area_type: ccrm,
                                          project: comcast_retail,
                                          created_at: ccrm_connect.created,
                                          updated_at: ccrm_connect.updated
    new_ccrm.save; new_ccrm.parent = new_ccrr; new_ccrm.save
    ccrts_connect = ccrm_connect.children
    ccrts_connect.each do |ccrt_connect|
      new_ccrt = Area.find_or_initialize_by name: ccrt_connect.name.gsub('Comcast - ', ''),
                                            area_type: ccrt,
                                            project: comcast_retail,
                                            created_at: ccrt_connect.created,
                                            updated_at: ccrt_connect.updated
      new_ccrt.save; new_ccrt.parent = new_ccrm; new_ccrt.save
    end
  end
end
