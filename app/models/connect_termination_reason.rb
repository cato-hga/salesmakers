# == Schema Information
#
# Table name: rc_term_reason
#
#  rc_term_reason_id :string(32)       not null, primary key
#  ad_client_id      :string(32)       not null
#  ad_org_id         :string(32)       not null
#  isactive          :string(1)        default("Y"), not null
#  created           :datetime         not null
#  createdby         :string(32)       not null
#  updated           :datetime         not null
#  updatedby         :string(32)       not null
#  reason            :string(255)      not null
#

class ConnectTerminationReason < ConnectModel
  self.table_name = :rc_term_reason
  self.primary_key = :rc_term_reason_id
end
