class WalmartGiftCardCheckJob < ActiveJob::Base
  queue_as :gift_card_checks

  def perform walmart_gift_cards, person = nil
    cards_to_save = []
    for gift_card_attributes in walmart_gift_cards do
      atts = gift_card_attributes.select { |key, value| ['link', 'challenge_code', 'card_number', 'pin'].include?(key) && value }
      if atts['link'] && !atts['challenge_code']
        gc = WalmartGiftCard.find_by link: atts['link']
      elsif atts['link'] && atts['challenge_code'] && !atts['card_number'] && !atts['pin']
        gc = WalmartGiftCard.find_or_initialize_by link: atts['link'], challenge_code: atts['challenge_code']
      else
        gc = WalmartGiftCard.find_or_initialize_by(atts)
      end
      gc.unique_code = gift_card_attributes['unique_code'] if gift_card_attributes['unique_code']
      cards_to_save << gc
    end

    for gift_card in cards_to_save do
      gift_card.check
      gift_card.save
    end

    WalmartGiftCardMailer.send_card_details(cards_to_save, person).deliver_later if person
  end
end