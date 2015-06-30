class DeviceNotesController < ApplicationController

  def create
    device = Device.find params[:device_id]
    note = params.require(:device_note).permit(:note)[:note]
    device_note = DeviceNote.new device: device,
                                 person: @current_person,
                                 note: note
    if device_note.save
      flash[:notice] = 'Note was saved successfully.'
    else
      flash[:error] = device_note.errors.full_messages.join(', ')
    end
    redirect_to device_path(device)
  end
end