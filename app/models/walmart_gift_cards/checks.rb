module WalmartGiftCards
  module Checks
    CARD_QUERY_PAGE = 'https://www.walmart.com/cservice/ProcessShoppingCard.do'

    def check
      return if link.blank?
      existing_card = WalmartGiftCard.find_by link: link
      self.attributes = existing_card.attributes if existing_card
      @agent = Mechanize.new
      tries = 1
      until (self.card_number && self.pin) || tries > 3
        tries += 1
        set_card_number_and_pin
      end
      tries = 1
      self.balance = nil
      until self.balance || tries > 3
        tries += 1
        set_balance_and_history if self.card_number && self.pin
      end
    end

    def set_card_number_and_pin
      sleep 1.25
      tries = 1
      begin
        page = @agent.get(link)
      rescue
        tries += 1
        sleep 2.5
        retry unless tries > 3
      end
      return if page.forms.empty?
      form = page.forms.first
      form.value = challenge_code
      page = @agent.submit form, form.buttons.first
      number_and_pin_elements = page.parser.css '#egc-codes p span' || return
      if number_and_pin_elements.count == 5
        self.card_number = number_and_pin_elements[0..3].map(&:text).join('')
        self.pin = number_and_pin_elements.last.text.sub('PIN: ', '')
      end
    end

    def set_balance_and_history
      sleep 1.25
      params = {
          'GetCardBalance.x' => '90',
          'GetCardBalance.y' => '8',
          'cardNumber' => self.card_number,
          'pin' => self.pin
      }
      tries = 1
      begin
        history_page = post_form_data CARD_QUERY_PAGE, params || return
      rescue
        tries += 1
        sleep 2.5
        retry unless tries > 3
      end
      # TODO: setting of VonageProduct
      doc = Nokogiri::HTML history_page
      history_elements = doc.css '.CheckCardBalance' || return
      return if history_elements.empty?
      set_balance history_elements
      set_purchase_info history_elements
    end

    private

    def post_form_data uri, params
      post_result = Net::HTTP.post_form URI.parse(uri), params
      post_result.body
    end

    def set_balance history_elements
      balance_string = history_elements.css('span').text.sub('$', '')
      return if balance_string.empty?
      self.balance = balance_string.to_f
    end

    def set_purchase_info history_elements
      if history_elements.css('tr').count < 4
        self.used = false
        return
      end
      purchase_element = history_elements.css('tr')[1]
      purchase_date_elements = purchase_element.css('.TransactDate .BodyM')
      return if purchase_date_elements.empty?
      self.purchase_date = DateTime.strptime(purchase_date_elements.text, '%m/%d/%Y').to_date
      self.used = true
      store_name_elements = purchase_element.css '.TransactDesc .BodyM div'
      return if store_name_elements.empty?
      self.store_number = store_name_elements.first.text.split.last.sub('#', '')
      purchase_amount_elements = purchase_element.css '.TransactAmnt .BodyM'
      return if purchase_amount_elements.empty?
      self.purchase_amount = purchase_amount_elements.first.text.sub('-', '').sub('$', '').to_f
    end
  end
end