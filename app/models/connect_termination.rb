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
