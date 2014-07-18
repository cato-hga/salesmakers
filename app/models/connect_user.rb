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

  def self.not_main_administrators
    self.where("username != 'retailingw@retaildoneright.com' AND username != 'aatkinson@retaildoneright.com' AND username != 'smiles@retaildoneright.com' AND (username LIKE '%@retaildoneright.com' OR username LIKE '%@rbd%.com') AND lower(firstname) != 'x' AND ad_org_id = '6B3C6669E32B43E1A1B14788C0CD0146' AND username NOT LIKE '%@%clear%.com'")
  end

  def self.creation_order
    self.order :created
  end

  def active?
    if isactive == 'Y'
      true
    else
      false
    end
  end

  def leader?
    if connect_regions.count > 0
      true
    else
      false
    end
  end

  def region
    if connect_regions.count < 1
      return nil unless supervisor.present? and supervisor.connect_regions.count > 0
      return supervisor.connect_regions.first
    else
      return connect_regions.first
    end
  end

  def project
    user_region = region
    return nil if user_region == nil
    region.project
  end
end