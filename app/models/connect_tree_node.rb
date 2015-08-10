# == Schema Information
#
# Table name: ad_treenode
#
#  ad_treenode_id :string(32)       not null, primary key
#  ad_tree_id     :string(32)       not null
#  node_id        :string(32)       not null
#  ad_client_id   :string(32)       not null
#  ad_org_id      :string(32)       not null
#  isactive       :string(1)        default("Y"), not null
#  created        :datetime         not null
#  createdby      :string(32)       not null
#  updated        :datetime         not null
#  updatedby      :string(32)       not null
#  parent_id      :string(32)
#  seqno          :decimal(10, )
#

class ConnectTreeNode < ConnectModel
  self.table_name = :ad_treenode
  self.primary_key = :ad_treenode_id

  belongs_to :owner_region, class_name: 'ConnectRegion', foreign_key: 'node_id'
  belongs_to :parent_region, class_name: 'ConnectRegion', foreign_key: 'parent_id'

end
