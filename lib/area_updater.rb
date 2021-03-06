require 'person_updater'

class AreaUpdater

  def self.update automated = false
    setup
    update_areas
    ProcessLog.create process_class: "AreaUpdater", records_processed: @count if automated
  end

  private

  def self.setup
    @count = 0
    setup_clients
    setup_projects
    setup_area_types
  end

  def self.setup_clients
    @vonage = Client.find_by name: 'Vonage'
    @rbh = Client.find_by name: 'Retail Business Holdings'
    @sprint = Client.find_by name: 'Sprint'
    @comcast = Client.find_by name: 'Comcast'
    @directv = Client.find_by name: 'DirecTV'
  end

  def self.setup_projects
    @vonage_retail = Project.find_by name: 'Vonage',
                                     client: @vonage
    @vonage_events = Project.find_by name: 'Vonage Events',
                                     client: @vonage
    @headquarters = Project.find_by name: 'RBD Company HQ',
                                    client: @rbh
    @sprint_prepaid = Project.find_by name: 'Sprint Prepaid',
                                     client: @sprint
    @star = Project.find_by name: 'STAR',
                                       client: @sprint
    @comcast_retail = Project.find_by name: 'Comcast Retail',
                                      client: @comcast
    @directv_retail = Project.find_by name: 'DirecTV Retail',
                                      client: @directv
  end

  def self.setup_area_types
    setup_vonage_area_types
    setup_sprint_prepaid_area_types
    setup_star_area_types
    setup_comcast_area_types
    setup_directv_area_types
  end

  def self.setup_vonage_area_types
    @vrr = AreaType.find_by name: 'Vonage Region',
                            project: @vonage_retail
    @vrm = AreaType.find_by name: 'Vonage Market',
                            project: @vonage_retail
    @vrt = AreaType.find_by name: 'Vonage Territory',
                            project: @vonage_retail
    @ver = AreaType.find_by name: 'Vonage Event Region',
                            project: @vonage_events
    @vem = AreaType.find_by name: 'Vonage Event Market',
                            project: @vonage_events
    @vet = AreaType.find_by name: 'Vonage Event Team',
                            project: @vonage_events
  end

  def self.setup_sprint_prepaid_area_types
    @srr = AreaType.find_by name: 'Sprint Prepaid Region',
                            project: @sprint_prepaid
    @srm = AreaType.find_by name: 'Sprint Prepaid Market',
                            project: @sprint_prepaid
    @srt = AreaType.find_by name: 'Sprint Prepaid Territory',
                            project: @sprint_prepaid
  end

  def self.setup_star_area_types
    @spr = AreaType.find_by name: 'STAR Region',
                            project: @star
    @spm = AreaType.find_by name: 'STAR Market',
                            project: @star
    @spt = AreaType.find_by name: 'STAR Territory',
                            project: @star
  end

  def self.setup_comcast_area_types
    @ccrr = AreaType.find_by name: 'Comcast Retail Region',
                             project: @comcast_retail
    @ccrm = AreaType.find_by name: 'Comcast Retail Market',
                             project: @comcast_retail
    @ccrt = AreaType.find_by name: 'Comcast Retail Territory',
                             project: @comcast_retail
  end

  def self.setup_directv_area_types
    @dtvrr = AreaType.find_by name: 'DirecTV Retail Region',
                              project: @directv_retail
    @dtvrm = AreaType.find_by name: 'DirecTV Retail Market',
                              project: @directv_retail
    @dtvrt = AreaType.find_by name: 'DirecTV Retail Territory',
                              project: @directv_retail
  end

  def self.sync_area(connect, area_type, project, parent_connect = nil)
    existing_area = Area.find_by connect_salesregion_id: connect.c_salesregion_id
    clean_name = Position.clean_area_name(connect)
    parent = parent_connect ? Area.find_by(connect_salesregion_id: parent_connect.c_salesregion_id) : nil
    active = connect.isactive == 'Y' ? true : false
    if not existing_area
      new_area = Area.create name: clean_name,
                             area_type: area_type,
                             project: project,
                             created_at: connect.created,
                             updated_at: connect.updated,
                             connect_salesregion_id: connect.c_salesregion_id,
                             active: active
      @count += 1
      if parent_connect
        new_area.update parent: parent if parent
      end
      new_area_manager = connect.manager
      PersonUpdater.new(new_area_manager).update if new_area_manager
    elsif not same_area?(existing_area, clean_name, area_type, project, parent, active)
      existing_area.update name: clean_name,
                           area_type: area_type,
                           project: project,
                           parent: parent,
                           active: active
      @count += 1
    end
  end

  def self.same_area?(area, name, area_type, project, parent, active)
    area.name == name &&
        area.area_type == area_type &&
        area.project == project &&
        (parent &&
            area.parent == parent) &&
        area.active? == active
  end

  def self.update_areas
    update_vonage_areas
    update_sprint_prepaid_areas
    update_star_areas
    update_comcast_areas
    update_directv_areas
  end

  def self.update_vonage_areas
    update_vonage_retail_areas
    update_vonage_event_areas
  end

  def self.update_vonage_retail_areas
    vr_connect = ConnectRegion.find_by value: 'Vonage Retail-1'
    vr_connect.children.each do |vrr_connect|
      sync_area vrr_connect, @vrr, @vonage_retail
      vrr_connect.children.each do |vrm_connect|
        sync_area vrm_connect, @vrm, @vonage_retail, vrr_connect
        vrm_connect.children.each do |vrt_connect|
          sync_area vrt_connect, @vrt, @vonage_retail, vrm_connect
        end
      end
    end
  end

  def self.update_vonage_event_areas
    ve_connect = ConnectRegion.find_by_value 'Vonage Events-1'
    ve_connect.children.each do |ver_connect|
      sync_area ver_connect, @ver, @vonage_events
      ver_connect.children.each do |vem_connect|
        sync_area vem_connect, @vem, @vonage_events, ver_connect
        vem_connect.children.each do |vet_connect|
          sync_area vet_connect, @vet, @vonage_events, vem_connect
        end
      end
    end
  end

  def self.update_sprint_prepaid_areas
    sr_connect = ConnectRegion.find_by_value 'Sprint-1'
    sr_connect.children.each do |srr_connect|
      sync_area srr_connect, @srr, @sprint_prepaid
      srr_connect.children.each do |srm_connect|
        sync_area srm_connect, @srm, @sprint_prepaid, srr_connect
        srm_connect.children.each do |srt_connect|
          sync_area srt_connect, @srt, @sprint_prepaid, srm_connect
        end
      end
    end
  end

  def self.update_star_areas
    sp_connect = ConnectRegion.find_by_value 'Sprint Postpaid-1'
    sp_connect.children.each do |spr_connect|
      sync_area spr_connect, @spr, @star
      spr_connect.children.each do |spm_connect|
        sync_area spm_connect, @spm, @star, spr_connect
        spm_connect.children.each do |spt_connect|
          sync_area spt_connect, @spt, @star, spm_connect
        end
      end
    end
  end

  def self.update_comcast_areas
    ccr_connect = ConnectRegion.find_by_value 'Comcast Retail-1'
    ccr_connect.children.each do |ccrr_connect|
      sync_area ccrr_connect, @ccrr, @comcast_retail
      ccrr_connect.children.each do |ccrm_connect|
        sync_area ccrm_connect, @ccrm, @comcast_retail, ccrr_connect
        ccrm_connect.children.each do |ccrt_connect|
          sync_area ccrt_connect, @ccrt, @comcast_retail, ccrm_connect
        end
      end
    end
  end

  def self.update_directv_areas
    dtvr_connect = ConnectRegion.find_by_value 'DirecTV-1'
    dtvr_connect.children.each do |dtvrr_connect|
      sync_area dtvrr_connect, @dtvrr, @directv_retail
      dtvrr_connect.children.each do |dtvrm_connect|
        sync_area dtvrm_connect, @dtvrm, @directv_retail, dtvrr_connect
        dtvrm_connect.children.each do |dtvrt_connect|
          sync_area dtvrt_connect, @dtvrt, @directv_retail, dtvrm_connect
        end
      end
    end
  end
end