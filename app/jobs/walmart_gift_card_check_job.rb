class WalmartGiftCardCheckJob < ActiveJob::Base
  queue_as :gift_card_checks

  def perform walmart_gift_cards, person = nil
    cards_to_save = []
    for gift_card_attributes in walmart_gift_cards do
      atts = gift_card_attributes.select { |key, value| ['link', 'challenge_code', 'card_number'].include?(key) && value }
      puts atts.inspect, ''
      gc = WalmartGiftCard.find_or_initialize_by(atts)
      gc.unique_code = gift_card_attributes['unique_code'] if gift_card_attributes['unique_code']
      gc.pin = gift_card_attributes['pin'] if gift_card_attributes['pin']
      cards_to_save << gc
    end

    for gift_card in cards_to_save do
      gift_card.check
      gift_card.save
      sleep 2.5
    end

    WalmartGiftCardMailer.send_card_details(cards_to_save, person).deliver_later if person
  end
end