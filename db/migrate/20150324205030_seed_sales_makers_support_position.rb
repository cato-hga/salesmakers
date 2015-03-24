class SeedSalesMakersSupportPosition < ActiveRecord::Migration
  def self.up
    department = Department.find_or_create_by name: 'SalesMakers Support',
                                              corporate: false
    position = Position.find_or_create_by name: 'SalesMakers Support Member',
                                          department: department,
                                          leadership: false,
                                          all_field_visibility: true,
                                          all_corporate_visibility: false
    permission_group = PermissionGroup.find_or_create_by name: 'Candidates'
    permission_index = Permission.find_or_create_by key: 'candidate_index',
                                                    description: 'can view index of Candidates',
                                                    permission_group: permission_group
    permission_create = Permission.find_or_create_by key: 'candidate_create',
                                                     description: 'can create Candidates',
                                                     permission_group: permission_group
    permission_view_all = Permission.find_or_create_by key: 'candidate_view_all',
                                                       description: "Can view all recruiter's candidates",
                                                       permission_group: permission_group
    position.permissions << permission_index
    position.permissions << permission_create
    position.permissions << permission_view_all
  end

  def self.down
    position = Position.find_by name: 'SalesMakers Support Member'
    position.permissions.destroy_all
    position.destroy
    Department.where(name: 'SalesMakers Support').destroy_all
  end
end
