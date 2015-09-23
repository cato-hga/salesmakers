puts "Adding RBD Connect salesregion ID's to Areas..."

vonage = Client.find_by name: 'Vonage'
rbh = Client.find_by name: 'Retail Business Holdings'
sprint = Client.find_by name: 'Sprint'
comcast = Client.find_by name: 'Comcast'

vonage_retail = Project.find_by name: 'Vonage',
                                client: vonage
vonage_events = Project.find_by name: 'Vonage Events',
                                client: vonage
headquarters = Project.find_by name: 'RBD Company HQ',
                               client: rbh
sprint_prepaid = Project.find_by name: 'Sprint Prepaid',
                                client: sprint
comcast_retail = Project.find_by name: 'Comcast Retail',
                            client: comcast

vrr = AreaType.find_by name: 'Vonage Region',
                       project: vonage_retail
vrm = AreaType.find_by name: 'Vonage Market',
                       project: vonage_retail
vrt = AreaType.find_by name: 'Vonage Territory',
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

srr = AreaType.find_by name: 'Sprint Prepaid Region',
                       project: sprint_prepaid
srt = AreaType.find_by name: 'Sprint Prepaid Territory',
                       project: sprint_prepaid

ccrr = AreaType.find_by name: 'Comcast Retail Region',
                        project: comcast_retail
ccrm = AreaType.find_by name: 'Comcast Retail Market',
                        project: comcast_retail
ccrt = AreaType.find_by name: 'Comcast Retail Territory',
                        project: comcast_retail

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
                        project: sprint_prepaid
  new_srr.update connect_salesregion_id: srr_connect.c_salesregion_id if new_srr
  srms_connect = srr_connect.children
  srms_connect.each do |srm_connect|
    srts_connect = srm_connect.children
    srts_connect.each do |srt_connect|
      new_srt = Area.find_by name: srt_connect.name.gsub('Sprint - ', ''),
                            area_type: srt,
                            project: sprint_prepaid
      new_srt.update connect_salesregion_id: srt_connect.c_salesregion_id if new_srt
    end
  end
end

ccr_connect = ConnectRegion.find_by_value 'Comcast Retail-1'
ccrrs_connect = ccr_connect.children
ccrrs_connect.each do |ccrr_connect|
  new_ccrr = Area.find_by name: ccrr_connect.name,
                         area_type: ccrr,
                         project: comcast_retail
  new_ccrr.update connect_salesregion_id: ccrr_connect.c_salesregion_id if new_ccrr
  ccrms_connect = ccrr_connect.children
  ccrms_connect.each do |ccrm_connect|
    new_ccrm = Area.find_by name: ccrm_connect.name,
                           area_type: ccrm,
                           project: comcast_retail
    new_ccrm.update connect_salesregion_id: ccrm_connect.c_salesregion_id if new_ccrm
    ccrts_connect = ccrm_connect.children
    ccrts_connect.each do |ccrt_connect|
      new_ccrt = Area.find_by name: ccrt_connect.name.gsub('Comcast - ', ''),
                             area_type: ccrt,
                             project: comcast_retail
      new_ccrt.update connect_salesregion_id: ccrt_connect.c_salesregion_id if new_ccrt
    end
  end
end