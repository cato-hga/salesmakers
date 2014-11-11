require 'active_shipping'
require 'apis/groupme'

class AssetShippingNotifier
  include ActiveMerchant::Shipping

  def initialize
    @fedex = FedEx.new login: 'RBDOperations',
                       password: '13F2491742jjiRzQiQvgsQ2fJ',
                       key: 'SgOmSL16OlhWHwfY',
                       account: '289194053'
    @groupme = GroupMe.new_global
  end

  def process_movements(hours)
    track_movements recent_movements(hours)
    for hal_mti in @held_at_location do
      person = Person.return_from_connect_user hal_mti.connect_asset_movement.moved_to_user
      next unless person
      group_me_group_num = person_group_me_group_num person
      next unless group_me_group_num
      send_group_me_hal_message(hal_mti, person, group_me_group_num)
    end
  end

  def send_group_me_hal_message(hal_mti, person, group_me_group_num)
    tracking_info = hal_mti.tracking_info
    return unless tracking_info.params
    pickup_location = pickup_location tracking_info
    return unless pickup_location
    asset_type = asset_type hal_mti.connect_asset_movement
    return unless asset_type
    track_reply = tracking_info.params['TrackReply']
    message = "#{person.display_name} has a package "
    message += "containing a #{asset_type} that is now "
    message += "awaiting pickup at #{pickup_location}."
    @groupme.send_message group_me_group_num,
                          message
  end

  def recent_movements(hours)
    ConnectAssetMovement.where 'created >= ? AND tracking IS NOT NULL',
                               Time.now - hours.hours
  end

  def asset_type(movement)
    return nil unless movement and
        movement.connect_asset and
        movement.connect_asset.connect_asset_group
    movement.connect_asset.connect_asset_group.name
  end

  def track_movements(movements)
    @delivered = Array.new
    @held_at_location = Array.new
    for movement in movements do
      begin
        tracking_info = @fedex.find_tracking_info movement.tracking
      rescue ActiveMerchant::Shipping::ResponseError
        puts "Error in response for #{movement.tracking}"
        next
      end
      unless has_events?(tracking_info)
        puts "Has no events"
        next
      end
      last_movement = tracking_info.shipment_events.last
      if last_movement.name.starts_with?('Held at')
        puts "#{movement.tracking} is a HAL that's arrived"
        @held_at_location << MovementTrackingInfo.new(movement, tracking_info)
      elsif last_movement.name.starts_with?('Delivered')
        @delivered << MovementTrackingInfo.new(movement, tracking_info)
      end
    end
  end

  def person_group_me_group_num(person)
    return nil unless person and person.person_areas.count > 0
    group_me_group_num = nil
    for person_area in person.person_areas do
      next unless person_area.area.groupme_group
      group_me_group_num = person_area.area.groupme_group
    end
    group_me_group_num
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
        tracking_info.params and
        tracking_info.params['TrackReply'] and
        tracking_info.params['TrackReply']['TrackDetails'] and
        tracking_info.params['TrackReply']['TrackDetails']['Events'] and
        tracking_info.params['TrackReply']['TrackDetails']['Events'][0] and
        tracking_info.params['TrackReply']['TrackDetails']['Events'][0]['Address']
    format_address tracking_info.params['TrackReply']['TrackDetails']['Events'][0]['Address']
  end

  def format_address(address)
    formatted = address['StreetLines'].strip
    formatted += ", #{address['City']}, #{address['StateOrProvinceCode']} #{address['PostalCode']}"
  end

end

class MovementTrackingInfo

  def initialize(connect_asset_movement, tracking_info)
    @connect_asset_movement = connect_asset_movement
    @tracking_info = tracking_info
  end

  def connect_asset_movement
    @connect_asset_movement
  end

  def tracking_info
    @tracking_info
  end

end