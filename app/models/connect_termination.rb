# == Schema Information
#
# Table name: rc_termination
#
#  rc_termination_id :string(32)       not null, primary key
#  ad_client_id      :string(32)       not null
#  ad_org_id         :string(32)       not null
#  isactive          :string(1)        default("Y"), not null
#  created           :datetime         not null
#  createdby         :string(32)       not null
#  updated           :datetime         not null
#  updatedby         :string(32)       not null
#  ad_user_id        :string(32)       not null
#  term_type         :string(60)       not null
#  rc_term_reason_id :string(32)       not null
#  termination_date  :datetime         not null
#  last_day_worked   :datetime         not null
#

class ConnectTermination < ConnectModel
  self.table_name = :rc_termination
  self.primary_key = :rc_termination_id

  belongs_to :connect_user,
             primary_key: 'ad_user_id',
             foreign_key: 'ad_user_id'
  belongs_to :connect_termination_reason,
             primary_key: 'rc_term_reason_id',
             foreign_key: 'rc_term_reason_id'

  default_scope { order last_day_worked: :desc }
end
