puts "Creating projects..."

vonage = Client.find_by_name 'Vonage'
rbh = Client.find_by_name 'Retail Business Holdings'
sprint = Client.find_by_name 'Sprint'
# rs = Client.find_by_name 'Rosetta Stone'

vonage_retail = Project.create name: 'Vonage Retail',
                               client: vonage
vonage_events = Project.create name: 'Vonage Events',
                               client: vonage
headquarters = Project.create name: 'RBD Company HQ',
                           client: rbh
sprint_retail = Project.create name: 'Sprint Retail',
                           client: sprint
rs_retail = Project.create name: 'Rosetta Stone Retail',
                           client: rs

vrr = AreaType.create name: 'Vonage Retail Region',
                      project: vonage_retail
vrm = AreaType.create name: 'Vonage Retail Market',
                      project: vonage_retail
vrt = AreaType.create name: 'Vonage Retail Territory',
                      project: vonage_retail
ver = AreaType.create name: 'Vonage Event Region',
                      project: vonage_events
vem = AreaType.create name: 'Vonage Event Market',
                      project: vonage_events
vet = AreaType.create name: 'Vonage Event Team',
                      project: vonage_events

hqo = AreaType.create name: 'Company HQ',
                     project: headquarters
hqd = AreaType.create name: 'HQ Department',
                     project: headquarters
hqt = AreaType.create name: 'HQ Team',
                     project: headquarters

srr = AreaType.create name: 'Sprint Retail Region',
                      project: sprint_retail
srt = AreaType.create name: 'Sprint Retail Territory',
                      project: sprint_retail

# rsrr = AreaType.create name: 'Rosetta Stone Retail Region',
#                       project: rs_retail
# rsrt = AreaType.create name: 'Rosetta Stone Retail Territory',
#                       project: rs_retail

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
    new_vem = Area.create name: vem_connect.name,
                          area_type: vem,
                          project: vonage_events,
                          parent: new_ver,
                          created_at: vem_connect.created,
                          updated_at: vem_connect.updated
    vets_connect = vem_connect.children
    vets_connect.each do |vet_connect|
      new_vet = Area.create name: vet_connect.name.gsub('Vonage Events - ', ''),
                            area_type: vet,
                            project: vonage_events,
                            parent: new_vem,
                            created_at: vet_connect.created,
                            updated_at: vet_connect.updated
    end
  end
end

#TODO Add  trees

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

# rsr_connect = ConnectRegion.find_by_value 'Rosetta Stone Retail-1'
# rsrrs_connect = rsr_connect.children
# rsrrs_connect.each do |rsrr_connect|
#   new_rsrr = Area.create name: rsrr_connect.name,
#                         area_type: rsrr,
#                         project: rs_retail,
#                         created_at: rsrr_connect.created,
#                         updated_at: rsrr_connect.updated
#   rsrms_connect = rsrr_connect.children
#   rsrms_connect.each do |rsrm_connect|
#     rsrts_connect = rsrm_connect.children
#     rsrts_connect.each do |rsrt_connect|
#       new_rsrt = Area.create name: rsrt_connect.name.gsub('Rosetta Stone - ', ''),
#                             area_type: rsrt,
#                             project: rs_retail,
#                             parent: new_rsrr,
#                             created_at: rsrt_connect.created,
#                             updated_at: rsrt_connect.updated
#     end
#   end
# end
