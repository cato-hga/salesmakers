class AttachmentsController < ApplicationController

  def new
    @attachable = params[:attachable_type].constantize.find params[:attachable_id]
    @attachment = Attachment.new
  end

  def create
    @attachable = attachment_params[:attachable_type].constantize.find attachment_params[:attachable_id]
    @attachment = Attachment.new attachment_params
    @attachment.person = @current_person
    if @attachment.save
      flash[:notice] = 'Attachment saved successfully.'
      redirect_to @attachable
    else
      render :new
    end
  end

  private

  def attachment_params
    params.require(:attachment).permit :name,
                                       :attachable_id,
                                       :attachable_type,
                                       :attachment
  end

end