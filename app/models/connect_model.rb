class ConnectModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :rbd_connect_production
  before_save :rbd_connect_attributes
  before_create :set_create_audit, :set_update_audit, :set_active
  before_update :set_update_audit

  def self.active
    self.where(isactive: 'Y')
  end

  def self.inactive
    self.where(isactive: 'N')
  end

  protected

  def rbd_connect_attributes
    set_uuid
    set_client_and_organization
  end

  def set_uuid
    unless self[self.class.primary_key]
      self[self.class.primary_key] = get_uuid
    end
  end

  def get_uuid
    self.class.connection.execute("SELECT get_uuid();")[0]["get_uuid"]
  end

  def set_client_and_organization
    unless self["ad_client_id"] and self["ad_org_id"]
      self["ad_client_id"] = "2C908AA22CBD1292012CBD1733590021"
      self["ad_org_id"] = "0"
    end
  end

  def set_create_audit
    unless self["created"] and self["createdby"]
      self["created"] = Time.now
      self["createdby"] = "2C908AA22CBD1292012CBD1735100034"
    end
  end

  def set_update_audit
    unless self["updated"] and self["updatedby"]
      self["updated"] = Time.now
      self["updatedby"] = "2C908AA22CBD1292012CBD1735100034"
    end
  end

  def set_active
    self["isactive"] = "Y"
  end
end