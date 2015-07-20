require 'active_shipping'
require 'apis/groupme'

class AssetShippingNotifier
  #include ActiveMerchant::Shipping

  def initialize
    @fedex = ActiveShipping::FedEx.new login: 'RBDOperations',
                                       password: '13F2491742jjiRzQiQvgsQ2fJ',
                                       key: 'SgOmSL16OlhWHwfY',
                                       account: '289194053'
    @groupme = GroupMe.new_global
  end

  def process_deployments hours, automated = false
    count = 0
    track_movements recent_movements(hours)
    for hal_mti in @held_at_location do
      person = hal_mti.deployment.person || next
      group_me_groups = person_group_me_groups person
      for group in group_me_groups do
        send_group_me_hal_message(hal_mti, person, group.group_num)
      end
      count += 1
    end
    ProcessLog.create process_class: "AssetShippingNotifier", records_processed: count if automated
  end

  def send_group_me_hal_message(hal_mti, person, group_me_group_num)
    tracking_info = hal_mti.tracking_info
    tracking_number = hal_mti.deployment.tracking_number
    return unless tracking_info.params
    asset_type = asset_type hal_mti.deployment
    return unless asset_type
    message = get_message person, tracking_number, asset_type, tracking_info
    return unless message
    puts message
    @groupme.send_message group_me_group_num,
                          message
  end

  def recent_movements(hours)
    DeviceDeployment.where 'created_at >= ? AND tracking_number IS NOT NULL',
                           Time.now - hours.hours
  end

  def asset_type(deployment)
    return unless deployment and
        deployment.device and
        deployment.device.device_model
    deployment.device.device_model.device_model_name
  end

  def track_movements(deployments)
    @delivered = Array.new
    @held_at_location = Array.new
    for deployment in deployments do
      begin
        puts deployment.tracking_number
        tracking_info = @fedex.find_tracking_info deployment.tracking_number
      rescue ActiveShipping::ResponseContentError, ActiveShipping::ShipmentNotFound, ActiveShipping::ResponseError
        next
      end
      unless has_events?(tracking_info)
        next
      end
      last_movement = tracking_info.shipment_events.last
      if last_movement.name.starts_with?('Held at')
        @held_at_location << DeploymentTrackingInfo.new(deployment, tracking_info)
      elsif last_movement.name.starts_with?('Delivered')
        @delivered << DeploymentTrackingInfo.new(deployment, tracking_info)
      end
    end
  end

  def person_group_me_groups(person)
    return nil unless person and person.person_areas.count > 0
    group_me_groups = []
    for person_area in person.person_areas do
      group_me_groups.concat person_area.area.find_group_me_groups
    end
    group_me_groups
  end

  def delivered
    @delivered
  end

  def held_at_location
    @held_at_location
  end

  def has_events?(tracking_info)
    tracking_info and
        tracking_info.shipment_events and
        tracking_info.shipment_events.last
  end

  def pickup_location(tracking_info)
    return nil unless tracking_info and
        tracking_info.params.
            andand['TrackReply'].
            andand['TrackDetails'].
            andand['Events'].
            andand[0].
            andand['Address']
    format_address tracking_info.params['TrackReply']['TrackDetails']['Events'][0]['Address']
  end

  def format_address(address)
    return nil unless address['StreetLines']
    formatted = address['StreetLines'].strip
    formatted += ", #{address['City']}, #{address['StateOrProvinceCode']} #{address['PostalCode']}"
  end

  private

  def get_message person, tracking_number, asset_type, tracking_info
    pickup_location = pickup_location tracking_info
    message = "#{person.display_name} has a package " +
        "with tracking ##{tracking_number} " +
        "containing a #{asset_type} that is now " +
        "awaiting pickup"
    if pickup_location
      message += " at #{pickup_location}."
    else
      last_shipment_event = tracking_info.shipment_events.last
      shipped_to_city = last_shipment_event.location.city
      shipped_to_state = last_shipment_event.location.state
      return unless shipped_to_city and shipped_to_state
      message += " at the FedEx office in #{shipped_to_city}, #{shipped_to_state}."
    end
    message
  end

end

class DeploymentTrackingInfo

  def initialize(deployment, tracking_info)
    @deployment = deployment
    @tracking_info = tracking_info
  end

  def deployment
    @deployment
  end

  def tracking_info
    @tracking_info
  end

end