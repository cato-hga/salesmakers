class WalmartGiftCardsController < ApplicationController
  after_action :verify_authorized

  def new
    authorize WalmartGiftCard.new
  end

  def new_override
    authorize GiftCardOverride.new
    @person = Person.find params[:person_id]
    @gift_card_override = GiftCardOverride.new creator: @current_person, person: @person
    if @person == @current_person
      render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false and return
    end
  end

  def create_override
    authorize GiftCardOverride.new
    @gift_card_override = GiftCardOverride.new gift_card_override_params
    @gift_card_override.override_card_number = rand(1000000000000000..9999999999999999).to_s
    render :new_override and return unless @gift_card_override.save
    @current_person.log? 'create', @gift_card_override
  end

  def create
    authorize WalmartGiftCard.new
    data = JSON.parse params[:gift_card_json]
    unless data && data['data']
      flash[:error] = 'Data did not submit successfully. Please contact support.'
      redirect_to new_walmart_gift_card_path and return
    end
    data = data['data']
    @gift_card_attributes = []
    for atts in data do
      link, challenge_code, card_number, pin, unique_code = atts[0], atts[1], atts[2], atts[3], atts[4]
      link = nil if link == ''
      challenge_code = nil if challenge_code == ''
      card_number = nil if card_number == ''
      pin = nil if pin == ''
      unique_code = nil if unique_code == ''
      pin = pin.rjust(4, '0') if pin
      next unless (link && challenge_code) || (card_number && pin)
      @gift_card_attributes << {
          'link' => link,
          'challenge_code' => challenge_code,
          'card_number' => card_number,
          'pin' => pin,
          'unique_code' => unique_code
      }
    end
    WalmartGiftCardCheckJob.perform_later @gift_card_attributes, @current_person
    seconds = (3.175 * @gift_card_attributes.count).round
    arrival = DateTime.now + seconds.seconds
    flash[:notice] = "Cards submitted. Your cards should arrive at around #{arrival.in_time_zone.strftime('%-l:%M%P')}."
    redirect_to new_walmart_gift_card_path
  end

  private

  def gift_card_override_params
    params.require(:gift_card_override).permit :creator_id, :person_id, :original_card_number, :ticket_number
  end
end
