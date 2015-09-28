class WalmartGiftCardMailer < ApplicationMailer
  default from: "giftcards@retaildoneright.com"

  def send_card_pickup_email card_count
    return unless card_count > 0
    @gift_card_count = card_count
    to_emails = get_senior_developer_emails || return
    to_emails << 'giftcards@retaildoneright.com'
    to_emails << 'jumartinez@retaildoneright.com'

    puts to_emails.inspect

    seconds = (4.25 * @gift_card_count).round
    @arrival = (DateTime.now + seconds.seconds).in_time_zone 'Eastern Time (US & Canada)'

    handle_send to: to_emails,
                subject: "#{@gift_card_count} Gift Cards Picked Up"
  end

  def send_card_details gift_cards, person = nil, subject = 'Walmart Gift Card Details'
    return if gift_cards.empty?
    @gift_card_count = gift_cards.count
    to_emails = get_senior_developer_emails || return
    if person
      to_emails << person.email
    else
      to_emails << 'giftcards@retaildoneright.com'
    end

    ar_gift_cards = WalmartGiftCard.where(id: gift_cards.map(&:id))

    attachments['gift_cards.csv'] = {
        mime_type: 'text/csv',
        content: ar_gift_cards.to_csv
    }

    handle_send to: to_emails,
                subject: subject
  end

  def send_rbdc_check_email gift_cards
    return if gift_cards.empty?

    ar_gift_cards = WalmartGiftCard.where(id: gift_cards.map(&:id))

    attachments['gift_cards.csv'] = {
        mime_type: 'text/csv',
        content: ar_gift_cards.to_csv
    }

    handle_send to: 'egiftcards@rbdconnect.com',
                subject: 'Balance Check'
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