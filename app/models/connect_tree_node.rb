#TODO: TEST ME
class ConnectTreeNode < ConnectModel
  self.table_name = :ad_treenode
  self.primary_key = :ad_treenode_id

  belongs_to :owner_region, class_name: 'ConnectRegion', foreign_key: 'node_id'
  belongs_to :parent_region, class_name: 'ConnectRegion', foreign_key: 'parent_id'

end
