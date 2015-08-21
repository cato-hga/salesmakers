class WalmartGiftCardMailer < ApplicationMailer
  default from: "giftcards@retaildoneright.com"

  def send_card_details gift_cards, person
    return if gift_cards.empty?
    @gift_card_count = gift_cards.count
    to_emails = get_senior_developer_emails || return
    to_emails << person.email

    ar_gift_cards = WalmartGiftCard.where(id: gift_cards.map(&:id))
    attachments['gift_cards.csv'] = {
        mime_type: 'text/csv',
        content: ar_gift_cards.to_csv
    }

    handle_send to: to_emails,
                subject: 'Walmart Gift Card Details'
  end

  private

  def get_senior_developer_emails
    positions = Position.where name: 'Senior Software Developer'
    return if positions.empty?
    people = Person.where(position: positions)
    return if people.empty?
    people.map { |person| person.email }
  end
end