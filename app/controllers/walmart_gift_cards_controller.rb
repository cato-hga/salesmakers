class WalmartGiftCardsController < ApplicationController
  after_action :verify_authorized

  def new
    authorize WalmartGiftCard.new
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
    arrival = DateTime.now.in_time_zone + seconds.seconds
    flash[:notice] = "Cards submitted. Your cards should arrive at around #{arrival.strftime('%-l:%M%P')}."
    redirect_to new_walmart_gift_card_path
  end
end
