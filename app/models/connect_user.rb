class ConnectUser < ConnectModel
  self.table_name = :ad_user
  self.primary_key = :ad_user_id
end