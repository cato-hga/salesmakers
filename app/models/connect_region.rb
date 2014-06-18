require 'simple_tree'

class ConnectRegion < ConnectModel
  include SimpleTree

  self.table_name = :c_salesregion
  self.primary_key = :c_salesregion_id

  default_scope { active.order :name }

  belongs_to :manager, class_name: 'ConnectUser',
             primary_key: 'ad_user_id',
             foreign_key: 'salesrep_id'
  belongs_to :parent_tree_node,
             class_name: 'ConnectTreeNode',
             primary_key: 'node_id',
             foreign_key: 'c_salesregion_id'
  has_many :child_tree_nodes,
           class_name: 'ConnectTreeNode',
           foreign_key: 'parent_id'

  def parent
    nodes = ConnectTreeNode.where node_id: parent_tree_node.node_id
    if nodes.count < 1
      nil
    else
      nodes[0].parent_region
    end
  end

  def children
    nodes = child_tree_nodes
    if nodes.count < 1
      Array.new
    else
      all_children = Array.new
      for child in nodes do
        owner_region = child.owner_region
        all_children << child.owner_region if owner_region.present?
      end
      all_children.sort_by { |c| c.name }
    end
  end
end