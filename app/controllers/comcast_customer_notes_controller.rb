class ComcastCustomerNotesController < ApplicationController

  def create
    comcast_customer = ComcastCustomer.find params[:comcast_customer_id]
    note = params.require(:comcast_customer_note).permit(:note)[:note]
    comcast_customer_note = ComcastCustomerNote.new comcast_customer: comcast_customer,
                                       person: @current_person,
                                       note: note
    if comcast_customer_note.save
      flash[:notice] = 'Note was saved successfully.'
    else
      flash[:error] = comcast_customer_note.errors.full_messages.join(', ')
    end
    redirect_to comcast_customer_path(comcast_customer)
  end

end