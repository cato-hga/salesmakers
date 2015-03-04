class SeedRadioShack < ActiveRecord::Migration
  def self.up
    sprint = Client.find_or_create_by name: 'Sprint'
    sprint_postpaid = Project.find_or_create_by name: 'Sprint Postpaid',
                                                client: sprint
    spr = AreaType.find_or_create_by name: 'Sprint Postpaid Region',
                                     project: sprint_postpaid
    spt = AreaType.find_or_create_by name: 'Sprint Postpaid Territory',
                                     project: sprint_postpaid
    sp_connect = ConnectRegion.find_by_value 'Sprint Postpaid-1'
    sprs_connect = sp_connect.children
    sprs_connect.each do |spr_connect|
      new_spr = Area.find_or_create_by name: spr_connect.name,
                                       area_type: spr,
                                       project: sprint_postpaid,
                                       created_at: spr_connect.created,
                                       updated_at: spr_connect.updated,
                                       connect_salesregion_id: spr_connect.id
      spms_connect = spr_connect.children
      spms_connect.each do |spm_connect|
        spts_connect = spm_connect.children
        spts_connect.each do |spt_connect|
          new_spt = Area.find_or_initialize_by name: spt_connect.name.gsub('Sprint Postpaid - ', ''),
                                               area_type: spt,
                                               project: sprint_postpaid,
                                               created_at: spt_connect.created,
                                               updated_at: spt_connect.updated,
                                               connect_salesregion_id: spt_connect.id
          new_spt.save; new_spt.parent = new_spr; new_spt.save
        end
      end
    end
    channel = Channel.find_or_create_by name: "Radio Shack"
    bp = ConnectBusinessPartner.find_by(name: 'Sprint Radio Shack') || return
    locs = bp.connect_business_partner_locations.where(isactive: 'Y')
    return unless locs and locs.count > 0
    count = 0
    for loc in locs do
      location = Location.return_from_connect_business_partner_location loc
      count += 1 if location
      if count % 50 == 0
        puts "Imported #{count} locations..."
      end
    end
  end

  def self.down
    radio_shack = Channel.find_by(name: 'Radio Shack') || return
    Location.where(channel: radio_shack).destroy_all
    radio_shack.destroy
    project = Project.find_by(name: 'Sprint Postpaid') || return
    project.areas.destroy_all
    project.area_types.destroy_all
    project.destroy
  end
end
