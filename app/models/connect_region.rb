# == Schema Information
#
# Table name: c_salesregion
#
#  c_salesregion_id :string(32)       not null, primary key
#  ad_client_id     :string(32)       not null
#  ad_org_id        :string(32)       not null
#  isactive         :string(1)        default("Y"), not null
#  created          :datetime         not null
#  createdby        :string(32)       not null
#  updated          :datetime         not null
#  updatedby        :string(32)       not null
#  value            :string(40)       not null
#  name             :string(60)       not null
#  description      :string(255)
#  issummary        :string(1)        default("N"), not null
#  salesrep_id      :string(32)
#  isdefault        :string(1)        default("N"), not null
#

require 'simple_tree'

class ConnectRegion < ConnectModel
  include SimpleTree

  self.table_name = :c_salesregion
  self.primary_key = :c_salesregion_id

  default_scope { order :name }

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

  def fast_type
    return value[-1].to_i
  end

  def division
    node_height = height
    cur_obj = self
    if node_height > 4 or not cur_obj.present?
      return nil
    elsif node_height == 4
      return self
    else
      while node_height < 4 and cur_obj.present? and cur_obj.parent.present? do
        node_height = node_height + 1
        cur_obj = cur_obj.parent
      end
      return cur_obj
    end
  end

  def project
    node_height = height
    cur_obj = self
    if node_height == 6 or not cur_obj.present?
      return nil
    elsif node_height == 5
      return self
    else
      while node_height < 5 and cur_obj.present? and cur_obj.parent.present? do
        node_height = node_height + 1
        cur_obj = cur_obj.parent
      end
      return cur_obj
    end
  end
end
