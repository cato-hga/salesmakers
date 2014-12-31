puts "Adding RBD Connect salesregion ID's to Areas..."

vonage = Client.find_by name: 'Vonage'
rbh = Client.find_by name: 'Retail Business Holdings'
sprint = Client.find_by name: 'Sprint'
# rs = Client.find_by name: 'Rosetta Stone'

vonage_retail = Project.find_by name: 'Vonage Retail',
                                client: vonage
vonage_events = Project.find_by name: 'Vonage Events',
                                client: vonage
headquarters = Project.find_by name: 'RBD Company HQ',
                               client: rbh
sprint_retail = Project.find_by name: 'Sprint Retail',
                                client: sprint
# rs_retail = Project.find_by name: 'Rosetta Stone Retail',
#                             client: rs

vrr = AreaType.find_by name: 'Vonage Retail Region',
                       project: vonage_retail
vrm = AreaType.find_by name: 'Vonage Retail Market',
                       project: vonage_retail
vrt = AreaType.find_by name: 'Vonage Retail Territory',
                       project: vonage_retail
ver = AreaType.find_by name: 'Vonage Event Region',
                       project: vonage_events
vem = AreaType.find_by name: 'Vonage Event Market',
                       project: vonage_events
vet = AreaType.find_by name: 'Vonage Event Team',
                       project: vonage_events

hqo = AreaType.find_by name: 'Company HQ',
                       project: headquarters
hqd = AreaType.find_by name: 'HQ Department',
                       project: headquarters
hqt = AreaType.find_by name: 'HQ Team',
                       project: headquarters

srr = AreaType.find_by name: 'Sprint Retail Region',
                       project: sprint_retail
srt = AreaType.find_by name: 'Sprint Retail Territory',
                       project: sprint_retail

# rsrr = AreaType.find_by name: 'Rosetta Stone Retail Region',
#                         project: rs_retail
# rsrt = AreaType.find_by name: 'Rosetta Stone Retail Territory',
#                         project: rs_retail

vr_connect = ConnectRegion.find_by_value 'Vonage Retail-1'
vrrs_connect = vr_connect.children
vrrs_connect.each do |vrr_connect|
  new_vrr = Area.find_by name: vrr_connect.name,
                         area_type: vrr,
                         project: vonage_retail
  new_vrr.update connect_salesregion_id: vrr_connect.c_salesregion_id if new_vrr
  vrms_connect = vrr_connect.children
  vrms_connect.each do |vrm_connect|
    new_vrm = Area.find_by name: vrm_connect.name,
                           area_type: vrm,
                           project: vonage_retail
    new_vrm.update connect_salesregion_id: vrm_connect.c_salesregion_id if new_vrm
    vrts_connect = vrm_connect.children
    vrts_connect.each do |vrt_connect|
      new_vrt = Area.find_by name: vrt_connect.name.gsub('Vonage Retail - ', ''),
                             area_type: vrt,
                             project: vonage_retail
      new_vrt.update connect_salesregion_id: vrt_connect.c_salesregion_id if new_vrt
    end
  end
end

ve_connect = ConnectRegion.find_by_value 'Vonage Events-1'
vers_connect = ve_connect.children
vers_connect.each do |ver_connect|
  new_ver = Area.find_by name: ver_connect.name,
                         area_type: ver,
                         project: vonage_events
  new_ver.update connect_salesregion_id: ver_connect.c_salesregion_id if new_ver
  vems_connect = ver_connect.children
  vems_connect.each do |vem_connect|
    new_vem = Area.find_by name: vem_connect.name,
                           area_type: vem,
                           project: vonage_events
    new_vem.update connect_salesregion_id: vem_connect.c_salesregion_id if new_vem
    vets_connect = vem_connect.children
    vets_connect.each do |vet_connect|
      new_vet = Area.find_by name: vet_connect.name.gsub('Vonage Events - ', ''),
                             area_type: vet,
                             project: vonage_events
      new_vet.update connect_salesregion_id: vet_connect.c_salesregion_id if new_vet
    end
  end
end

#TODO Add  trees

sr_connect = ConnectRegion.find_by_value 'Sprint-1'
srrs_connect = sr_connect.children
srrs_connect.each do |srr_connect|
  new_srr = Area.find_by name: srr_connect.name,
                        area_type: srr,
                        project: sprint_retail
  new_srr.update connect_salesregion_id: srr_connect.c_salesregion_id if new_srr
  srms_connect = srr_connect.children
  srms_connect.each do |srm_connect|
    srts_connect = srm_connect.children
    srts_connect.each do |srt_connect|
      new_srt = Area.find_by name: srt_connect.name.gsub('Sprint - ', ''),
                            area_type: srt,
                            project: sprint_retail
      new_srt.update connect_salesregion_id: srt_connect.c_salesregion_id if new_srt
    end
  end
end

# rsr_connect = ConnectRegion.find_by_value 'Rosetta Stone Retail-1'
# rsrrs_connect = rsr_connect.children
# rsrrs_connect.each do |rsrr_connect|
#   new_rsrr = Area.find_by name: rsrr_connect.name,
#                          area_type: rsrr,
#                          project: rs_retail
#   new_rsrr.update connect_salesregion_id: rsrr_connect.c_salesregion_id if new_rsrr
#   rsrms_connect = rsrr_connect.children
#   rsrms_connect.each do |rsrm_connect|
#     rsrts_connect = rsrm_connect.children
#     rsrts_connect.each do |rsrt_connect|
#       new_rsrt = Area.find_by name: rsrt_connect.name.gsub('Rosetta Stone - ', ''),
#                              area_type: rsrt,
#                              project: rs_retail
#       new_rsrt.update connect_salesregion_id: rsrt_connect.c_salesregion_id if new_rsrt
#     end
#   end
# end