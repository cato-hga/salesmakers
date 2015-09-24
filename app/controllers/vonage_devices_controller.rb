class VonageDevicesController < ApplicationController
  before_action :do_authorization
  before_action :chronic_time_zones, only: [:create]
  before_action :set_vonage_employees, only: [:transfer, :reclaim]
  after_action :verify_authorized

  def index
    @vonage_devices = VonageDevice.all
  end

  def new
    @vonage_device = VonageDevice.new
  end

  def show
    @walmart_gift_card = WalmartGiftCard.find_by card_number: @vonage_sale.gift_card_number if @walmart_gift_card
    @project = Project.find_by name: 'Vonage' if @project
    @vonage_sale = VonageSale.find params[:id] if @vonage_sale
    @vonage_device = VonageDevice.find params[:id]
    @log_entries = LogEntry.where("(trackable_type = 'VonageDevice' AND trackable_id = ?) OR (referenceable_type = 'VonageDevice' AND referenceable_id = ?)", @vonage_device.id, @vonage_device.id)
    @log_entries = @log_entries.page(params[:log_entries_page]).per(10)
  end

  def transfer
    @vonage_transfer = VonageTransfer.new
    @vonage_devices = @current_person.vonage_devices
  end

  def do_transfer
    if params[:to_person].blank?
      flash[:error] = "Must select an employee."
      redirect_to transfer_vonage_devices_path and return
    end
    to_person = Person.find params[:to_person]
    vonage_device_ids = params[:vonage_devices]
    invalids = 0
    invalid_macs = []
    if vonage_device_ids == nil
      flash[:error] = "Must select Mac Id(s)"
      redirect_to transfer_vonage_devices_path and return
    end
    for device in vonage_device_ids do
      vonage_device = VonageDevice.find device
      transfer = VonageTransfer.new to_person: to_person,
                                    from_person: @current_person,
                                    vonage_device: vonage_device,
                                    transfer_time: DateTime.now
      @current_person.log? 'transfer',
                           vonage_device,
                           transfer

      if transfer.save
        vonage_device.update person: to_person
      else
        invalid_macs << vonage_device.mac_id
        invalids += 1
      end
    end
    if invalids == 0
      #SUCCESS
      flash[:notice] = 'Devices have been transferred.'
      redirect_to transfer_vonage_devices_path
    else
      flash[:error] = "The following MAC ID's could not be transferred. Please submit a support ticket with a screenshot of this page. #{invalid_macs.join(', ')}"
      redirect_to transfer_vonage_devices_path
    end
  end

  def accept
    @transfer_devices = VonageTransfer.where("to_person_id = ? and (accepted = false and rejected = false)", @current_person.id)
  end

  def do_accept
    accepted = params[:vonage_accepted]
    rejected = params[:vonage_rejected]
    accepted_transfers = []
    rejected_transfers = []
    unless accepted.blank?
      for accept in accepted
        transfer = VonageTransfer.find accept.to_i
        transfer.update accepted: true
        accepted_transfers << transfer
        @current_person.log? 'accept',
                             transfer.vonage_device,
                             transfer

      end
    end
    unless rejected.blank?
      for reject in rejected
        transfer = VonageTransfer.find reject.to_i
        device = transfer.vonage_device
        transfer.update rejected: true, rejection_time: DateTime.now
        device.update person: transfer.from_person
        rejected_transfers << transfer
        @current_person.log? 'reject',
                             device,
                             transfer

      end
    end

    if accepted.blank? and rejected.blank?
      flash[:error] = 'You must accept/reject a device.'
      redirect_to accept_vonage_devices_path
    else
      VonageInventoryMailer.inventory_accept_mailer(@current_person, accepted_transfers, rejected_transfers).deliver_later
      flash[:notice] = 'Accepted and Rejected devices are complete. Please check your email for further details.'
      redirect_to :root
    end
  end

  def reclaim
    @vonage_employees = @vonage_employees.reject! { |x| x.vonage_devices == [] }
    inactive_team_members = @current_person.team_members.where(active: false).joins(:vonage_devices).where('vonage_devices.id is not null')
    for member in inactive_team_members do
      @vonage_employees << member
    end
    @vonage_employees = @vonage_employees.uniq
  end

  def employees_reclaim
    if params[:to_person].blank?
      flash[:error] = "Must select an employee."
      redirect_to reclaim_vonage_devices_path and return
    end
    set_vonage_employees
    @vonage_employees = @vonage_employees.reject! { |x| x.vonage_devices == [] }
    inactive_team_members = @current_person.team_members.where(active: false).joins(:vonage_devices).where('vonage_devices.id is not null')
    for member in inactive_team_members do
      @vonage_employees << member
    end
    @vonage_employees = @vonage_employees.uniq
    @devices = VonageDevice.where(person_id: params[:to_person])
  end

  def do_reclaim
    if params[:vonage_devices].blank?
      flash[:error] = "You must select a device to reclaim."
      redirect_to employees_reclaim_vonage_devices_path(to_person: params[:to_person]) and return
    end
    devices = []
    vonage_device_ids = params[:vonage_devices]
    invalids_count = 0
    for reclaim in vonage_device_ids do
      vonage_device = VonageDevice.find reclaim
      device = [vonage_device.person.id, vonage_device.id]
      person = vonage_device.person
      @current_person.log? 'reclaim',
                          vonage_device,
                          person
      if vonage_device.update person: @current_person
        devices << device
      else
        invalids_count += 1
      end
    end

    if invalids_count > 0
      flash[:error] = 'Unable to reclaim all devices. Check your email for a list of all devices reclaimed.'
      VonageInventoryMailer.inventory_reclaim_mailer(@current_person, devices).deliver_later
      redirect_to reclaim_vonage_devices_path
    else
      VonageInventoryMailer.inventory_reclaim_mailer(@current_person, devices).deliver_later
      flash[:notice] = 'Your devices have been successfully reclaimed. Please check your email for further details. '
      redirect_to new_vonage_sale_path
    end
  end

  def create
    @vonage_device = VonageDevice.new
    @vonage_transfer = VonageTransfer.new
    receive_date = params.permit(:receive_date)[:receive_date]
    chronic_time = Chronic.parse(receive_date)
    adjusted_time = chronic_time.present? ? chronic_time.in_time_zone : nil
    po_number = vonage_device_params[:po_number]
    mac_ids = vonage_device_params[:mac_id]
    @vonage_device_ids = []
    for mac_id in mac_ids do
      vonage_device = VonageDevice.create person: @current_person,
                                          po_number: po_number,
                                          receive_date: adjusted_time,
                                          mac_id: mac_id
      @current_person.log? 'create',
                           vonage_device

      @vonage_device_ids << vonage_device.id
    end
    @vonage_device_ids.compact!
    unless @vonage_device_ids.empty?
      VonageInventoryMailer.inventory_receiving_mailer(@current_person, @vonage_device_ids).deliver_later
      redirect_to transfer_vonage_devices_path
    else
      render :new
    end
  end

  private

  def set_vonage_employees
    @vonage_employees = @current_person.managed_team_members.sort_by { |n| n[:display_name] }
    @vonage_employees = @vonage_employees.reject! { |x| x == @current_person }
  end

  def vonage_device_params
    params.permit :person_id,
                  :po_number,
                  mac_id: []
  end

  def do_authorization
    authorize VonageDevice.new
  end

  def chronic_time_zones
    Chronic.time_class = Time.zone
  end

end