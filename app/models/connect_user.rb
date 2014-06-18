class ConnectUser < ConnectModel
  self.table_name = :ad_user
  self.primary_key = :ad_user_id

  has_many :connect_regions,
           foreign_key: 'salesrep_id'
  has_one :user
  belongs_to :supervisor,
             class_name: 'ConnectUser'
  has_many :employees,
           class_name: 'ConnectUser',
           foreign_key: 'supervisor_id'
end