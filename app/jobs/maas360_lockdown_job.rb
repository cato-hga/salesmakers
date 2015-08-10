require 'apis/maas'

class MaaS360LockdownJob < ActiveJob::Base
  queue_as :default

  def perform(person)
    return unless person
    @maas = Maas.new
    person.devices.each do |device|
      maas_360_device_id = get_maas_360_device_id device || next
      policy_name = get_policy_name maas_360_device_id || next
      return if policy_name.include?('Lockdown')
      @maas.change_device_policy maas_360_device_id, policy_name + ' Lockdown'
    end

  end

  private

  def get_maas_360_device_id device
    all_but_last_digit = device.serial.first device.serial.length - 1
    ldap_username = device.person.email.first device.person.email.index('@')
    meid_and_username_search = @maas.meid_and_username_search all_but_last_digit, ldap_username
    meid_and_username_search.andand['devices'].andand['device'].andand['maas360DeviceID']
  end

  def get_policy_name maas_360_device_id
    security_and_compliance_attributes = @maas.security_and_compliance_attributes maas_360_device_id
    attributes = security_and_compliance_attributes.andand['securityCompliance'].andand['complianceAttributes'].andand['complianceAttribute'] || return
    policy_names = attributes.select { |attribute| attribute['key'] == 'MDM Policy Name' }
    return if policy_names.empty?
    policy_names.first.andand['value']
  end
end