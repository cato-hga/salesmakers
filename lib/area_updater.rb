require 'person_updater'

class AreaUpdater

  def self.update
    setup
    update_areas
  end

  private

  def self.setup
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
    @vonage_retail = Project.find_by name: 'Vonage Retail',
                                     client: @vonage
    @vonage_events = Project.find_by name: 'Vonage Events',
                                     client: @vonage
    @headquarters = Project.find_by name: 'RBD Company HQ',
                                    client: @rbh
    @sprint_retail = Project.find_by name: 'Sprint Retail',
                                     client: @sprint
    @sprint_postpaid = Project.find_by name: 'Sprint Postpaid',
                                       client: @sprint
    @comcast_retail = Project.find_by name: 'Comcast Retail',
                                      client: @comcast
    @directv_retail = Project.find_by name: 'DirecTV Retail',
                                      client: @directv
  end

  def self.setup_area_types
    setup_vonage_area_types
    setup_sprint_retail_area_types
    setup_sprint_postpaid_area_types
    setup_comcast_area_types
    setup_directv_area_types
  end

  def self.setup_vonage_area_types
    @vrr = AreaType.find_by name: 'Vonage Retail Region',
                            project: @vonage_retail
    @vrm = AreaType.find_by name: 'Vonage Retail Market',
                            project: @vonage_retail
    @vrt = AreaType.find_by name: 'Vonage Retail Territory',
                            project: @vonage_retail
    @ver = AreaType.find_by name: 'Vonage Event Region',
                            project: @vonage_events
    @vem = AreaType.find_by name: 'Vonage Event Market',
                            project: @vonage_events
    @vet = AreaType.find_by name: 'Vonage Event Team',
                            project: @vonage_events
  end

  def self.setup_sprint_retail_area_types
    @srr = AreaType.find_by name: 'Sprint Retail Region',
                            project: @sprint_retail
    @srm = AreaType.find_by name: 'Sprint Retail Market',
                            project: @sprint_retail
    @srt = AreaType.find_by name: 'Sprint Retail Territory',
                            project: @sprint_retail
  end

  def self.setup_sprint_postpaid_area_types
    @spr = AreaType.find_by name: 'Sprint Postpaid Region',
                            project: @sprint_postpaid
    @spm = AreaType.find_by name: 'Sprint Postpaid Market',
                            project: @sprint_postpaid
    @spt = AreaType.find_by name: 'Sprint Postpaid Territory',
                            project: @sprint_postpaid
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
    if not existing_area
      new_area = Area.create name: clean_name,
                             area_type: area_type,
                            project: project,
                            created_at: connect.created,
                            updated_at: connect.updated,
                            connect_salesregion_id: connect.c_salesregion_id
      if parent_connect
        new_area.update parent: parent if parent
      end
      new_area_manager = connect.manager
      PersonUpdater.new(new_area_manager).update if new_area_manager
    elsif not same_area?(existing_area, clean_name, area_type, project, parent)
      existing_area.update name: clean_name,
                           area_type: area_type,
                           project: project,
                           parent: parent
    end
  end

  def self.same_area?(area, name, area_type, project, parent)
    area.name == name &&
        area.area_type == area_type &&
        area.project == project &&
        (parent &&
            area.parent == parent)
  end

  def self.update_areas
    update_vonage_areas
    update_sprint_retail_areas
    update_sprint_postpaid_areas
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

  def self.update_sprint_retail_areas
    sr_connect = ConnectRegion.find_by_value 'Sprint-1'
    sr_connect.children.each do |srr_connect|
      sync_area srr_connect, @srr, @sprint_retail
      srr_connect.children.each do |srm_connect|
        sync_area srm_connect, @srm, @sprint_retail, srr_connect
        srm_connect.children.each do |srt_connect|
          sync_area srt_connect, @srt, @sprint_retail, srm_connect
        end
      end
    end
  end

  def self.update_sprint_postpaid_areas
    sp_connect = ConnectRegion.find_by_value 'Sprint Postpaid-1'
    sp_connect.children.each do |spr_connect|
      sync_area spr_connect, @spr, @sprint_postpaid
      spr_connect.children.each do |spm_connect|
        sync_area spm_connect, @spm, @sprint_postpaid, spr_connect
        spm_connect.children.each do |spt_connect|
          sync_area spt_connect, @spt, @sprint_postpaid, spm_connect
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