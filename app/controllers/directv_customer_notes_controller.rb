class DirecTVCustomerNotesController < ApplicationController

  def create
    directv_customer = DirecTVCustomer.find params[:directv_customer_id]
    note = params.require(:directv_customer_note).permit(:note)[:note]
    directv_customer_note = DirecTVCustomerNote.new directv_customer: directv_customer,
                                                    person: @current_person,
                                                    note: note
    if directv_customer_note.save
      flash[:notice] = 'Note was saved successfully.'
    else
      flash[:error] = directv_customer_note.errors.full_messages.join(', ')
    end
    redirect_to directv_customer_path(directv_customer)
  end

end