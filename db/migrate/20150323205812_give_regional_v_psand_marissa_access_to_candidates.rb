class GiveRegionalVPsandMarissaAccessToCandidates < ActiveRecord::Migration
  def self.up
    jeff = Person.find_by email: 'jparlette@retaildoneright.com'
    pos_spr_vp = Position.find_by_name 'Sprint Retail Regional Vice President'
    jeff.update position: pos_spr_vp

    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group

    for position in get_positions do
      position.permissions << permission_index
      position.permissions << permission_create
    end
  end

  def self.down
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: "Can view candidates",
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: "Can view candidates",
                                                     permission_group: permission_group
    for position in get_positions do
      position.permissions.delete permission_index
      position.permissions.delete permission_create
    end
  end

  def get_positions
    pos_vg_vp = Position.find_by_name 'Vonage Retail Regional Vice President'
    pos_spr_vp = Position.find_by_name 'Sprint Retail Regional Vice President'
    pos_com_vp = Position.find_by_name 'Comcast Retail Regional Viceesident'
    pos_spr_rm = Position.find_by_name 'Sprint Retail Regional Manager'
    pos_vp_sales = Position.find_by_name 'Vice President of Sales'

    [
        pos_com_vp,
        pos_spr_vp,
        pos_vg_vp,
        pos_spr_rm,
        pos_vp_sales
    ].compact
  end
end
