require 'person_updater'

class AreaUpdater

  def self.update
    vonage = Client.find_by name: 'Vonage'
    rbh = Client.find_by name: 'Retail Business Holdings'
    sprint = Client.find_by name: 'Sprint'
    rs = Client.find_by name: 'Rosetta Stone'

    vonage_retail = Project.find_by name: 'Vonage Retail',
                                   client: vonage
    vonage_events = Project.find_by name: 'Vonage Events',
                                   client: vonage
    headquarters = Project.find_by name: 'RBD Company HQ',
                                  client: rbh
    sprint_retail = Project.find_by name: 'Sprint Retail',
                                   client: sprint
    rs_retail = Project.find_by name: 'Rosetta Stone Retail',
                               client: rs

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

    rsrr = AreaType.find_by name: 'Rosetta Stone Retail Region',
                           project: rs_retail
    rsrt = AreaType.find_by name: 'Rosetta Stone Retail Territory',
                           project: rs_retail

    vr_connect = ConnectRegion.find_by value: 'Vonage Retail-1'
    vrrs_connect = vr_connect.children
    vrrs_connect.each do |vrr_connect|
      new_vrr = Area.find_by connect_salesregion_id: vrr_connect.c_salesregion_id
      unless new_vrr
        new_vrr = Area.create name: vrr_connect.name,
                              area_type: vrr,
                              project: vonage_retail,
                              created_at: vrr_connect.created,
                              updated_at: vrr_connect.updated,
                              connect_salesregion_id: vrr_connect.c_salesregion_id
        new_vrr_manager = vrr_connect.manager
        PersonUpdater.new(new_vrr_manager).update if new_vrr_manager
      end
      vrms_connect = vrr_connect.children
      vrms_connect.each do |vrm_connect|
        new_vrm = Area.find_by connect_salesregion_id: vrm_connect.c_salesregion_id
        unless new_vrm
          new_vrm = Area.create name: vrm_connect.name,
                                area_type: vrm,
                                project: vonage_retail,
                                parent: new_vrr,
                                created_at: vrm_connect.created,
                                updated_at: vrm_connect.updated,
                                connect_salesregion_id: vrm_connect.c_salesregion_id
          new_vrm_manager = vrm_connect.manager
          PersonUpdater.new(new_vrm_manager).update if new_vrm_manager
        end
        if new_vrm.parent and
            new_vrm.parent.connect_salesregion_id and
            new_vrm.parent.connect_salesregion_id != new_vrr.connect_salesregion_id
          new_vrm.update parent: new_vrr
        end
        vrts_connect = vrm_connect.children
        vrts_connect.each do |vrt_connect|
          new_vrt = Area.find_by connect_salesregion_id: vrt_connect.c_salesregion_id
          unless new_vrt
            new_vrt = Area.create name: vrt_connect.name.gsub('Vonage Retail - ', ''),
                                  area_type: vrt,
                                  project: vonage_retail,
                                  parent: new_vrm,
                                  created_at: vrt_connect.created,
                                  updated_at: vrt_connect.updated,
                                  connect_salesregion_id: vrt_connect.c_salesregion_id
            new_vrt_manager = vrt_connect.manager
            PersonUpdater.new(new_vrt_manager).update if new_vrt_manager
          end
          if new_vrt.parent and
              new_vrt.parent.connect_salesregion_id and
              new_vrt.parent.connect_salesregion_id != new_vrm.connect_salesregion_id
            new_vrt.update parent: new_vrm
          end
        end
      end
    end

    ve_connect = ConnectRegion.find_by_value 'Vonage Events-1'
    vers_connect = ve_connect.children
    vers_connect.each do |ver_connect|
      new_ver = Area.find_by connect_salesregion_id: ver_connect.c_salesregion_id
      unless new_ver
        new_ver = Area.create name: ver_connect.name,
                              area_type: ver,
                              project: vonage_events,
                              created_at: ver_connect.created,
                              updated_at: ver_connect.updated,
                              connect_salesregion_id: ver_connect.c_salesregion_id
        new_ver_manager = ver_connect.manager
        PersonUpdater.new(new_ver_manager).update if new_ver_manager
      end
      vems_connect = ver_connect.children
      vems_connect.each do |vem_connect|
        new_vem = Area.find_by connect_salesregion_id: vem_connect.c_salesregion_id
        unless new_vem
          new_vem = Area.create name: vem_connect.name,
                                area_type: vem,
                                project: vonage_events,
                                parent: new_ver,
                                created_at: vem_connect.created,
                                updated_at: vem_connect.updated,
                                connect_salesregion_id: vem_connect.c_salesregion_id
          new_vem_manager = vem_connect.manager
          PersonUpdater.new(new_vem_manager).update if new_vem_manager
        end
        if new_vem.parent and
            new_vem.parent.connect_salesregion_id and
            new_vem.parent.connect_salesregion_id != new_ver.connect_salesregion_id
          new_vem.update parent: new_ver
        end
        vets_connect = vem_connect.children
        vets_connect.each do |vet_connect|
          new_vet = Area.find_by connect_salesregion_id: vet_connect.c_salesregion_id
          unless new_vet
            new_vet = Area.create name: vet_connect.name.gsub('Vonage Events - ', ''),
                                  area_type: vet,
                                  project: vonage_events,
                                  parent: new_vem,
                                  created_at: vet_connect.created,
                                  updated_at: vet_connect.updated,
                                  connect_salesregion_id: vet_connect.c_salesregion_id
            new_vet_manager = vet_connect.manager
            PersonUpdater.new(new_vet_manager).update if new_vet_manager
          end
          if new_vet.parent and
              new_vet.parent.connect_salesregion_id and
              new_vet.parent.connect_salesregion_id != new_vem.connect_salesregion_id
            new_vet.update parent: new_vem
          end
        end
      end
    end

    sr_connect = ConnectRegion.find_by_value 'Sprint-1'
    srrs_connect = sr_connect.children
    srrs_connect.each do |srr_connect|
      new_srr = Area.find_by connect_salesregion_id: srr_connect.c_salesregion_id
      unless new_srr
        new_srr = Area.create name: srr_connect.name,
                              area_type: srr,
                              project: sprint_retail,
                              created_at: srr_connect.created,
                              updated_at: srr_connect.updated,
                              connect_salesregion_id: srr_connect.c_salesregion_id
        new_srr_manager = srr_connect.manager
        PersonUpdater.new(new_srr_manager).update if new_srr_manager
      end
      srms_connect = srr_connect.children
      srms_connect.each do |srm_connect|
        srts_connect = srm_connect.children
        srts_connect.each do |srt_connect|
          new_srt = Area.find_by connect_salesregion_id: srt_connect.c_salesregion_id
          unless new_srt
            new_srt = Area.create name: srt_connect.name.gsub('Sprint - ', ''),
                                  area_type: srt,
                                  project: sprint_retail,
                                  parent: new_srr,
                                  created_at: srt_connect.created,
                                  updated_at: srt_connect.updated,
                                  connect_salesregion_id: srt_connect.c_salesregion_id
            new_srt_manager = srt_connect.manager
            PersonUpdater.new(new_srt_manager).update if new_srt_manager
          end
          if new_srt.parent and
              new_srt.parent.connect_salesregion_id and
              new_srt.parent.connect_salesregion_id != new_srr.connect_salesregion_id
            new_srt.update parent: new_srr
          end
        end
      end
    end

    rsr_connect = ConnectRegion.find_by_value 'Rosetta Stone Retail-1'
    rsrrs_connect = rsr_connect.children
    rsrrs_connect.each do |rsrr_connect|
      new_rsrr = Area.find_by connect_salesregion_id: rsrr_connect.c_salesregion_id
      unless new_rsrr
        new_rsrr = Area.create name: rsrr_connect.name,
                               area_type: rsrr,
                               project: rs_retail,
                               created_at: rsrr_connect.created,
                               updated_at: rsrr_connect.updated,
                               connect_salesregion_id: rsrr_connect.c_salesregion_id
        new_rsrr_manager = rsrr_connect.manager
        PersonUpdater.new(new_rsrr_manager).update if new_rsrr_manager
      end
      rsrms_connect = rsrr_connect.children
      rsrms_connect.each do |rsrm_connect|
        rsrts_connect = rsrm_connect.children
        rsrts_connect.each do |rsrt_connect|
          new_rsrt = Area.find_by connect_salesregion_id: rsrt_connect.c_salesregion_id
          unless new_rsrt
            new_rsrt = Area.create name: rsrt_connect.name.gsub('Rosetta Stone - ', ''),
                                   area_type: rsrt,
                                   project: rs_retail,
                                   parent: new_rsrr,
                                   created_at: rsrt_connect.created,
                                   updated_at: rsrt_connect.updated,
                                   connect_salesregion_id: rsrt_connect.c_salesregion_id
            new_rsrt_manager = rsrt_connect.manager
            PersonUpdater.new(new_rsrt_manager).update if new_rsrt_manager
          end
          if new_rsrt.parent and
              new_rsrt.parent.connect_salesregion_id and
              new_rsrt.parent.connect_salesregion_id != new_rsrr.connect_salesregion_id
            new_rsrt.update parent: new_rsrr
          end
        end
      end
    end
  end

end