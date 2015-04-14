module Groupme
  module Bots
    def get_bots
      response = doGet '/bots'
      return unless response and response['response']
      response['response']
    end

    def destroy_bot(bot_id)
      payload = {
          bot_id: bot_id
      }.to_json
      doPost '/bots/destroy', payload
    end

    def add_bot(name, group_id, callback_url = nil, avatar_url = 'https://i.groupme.com/1127x1127.png.51d265a13ce44925aaa15a4e6a2b7b0e')
      new_bot = {
          bot: {
              name: name,
              group_id: group_id,
              callback_url: callback_url,
              avatar_url: avatar_url
          }
      }.to_json
      response = doPost '/bots', new_bot
      return nil unless response and
          response['response'] and
          response['response']['bot']
      response['response']['bot']['bot_id']
    end

    def post_messages_with_bot(messages, bot_id, image_url = nil)
      return unless messages and messages.count > 0 and bot_id
      count = 0
      for message in messages do
        count += 1
        sleep(0.1)
        payload = {
            'bot_id' => bot_id,
            'text' => message
        }
        if image_url and count == 1
          payload['attachments'] = [{
                                        'type' => 'image',
                                        'url' => image_url
                                    }]
        end
        payload = payload.to_json
        response = self.class.post '/bots/post', { body: payload }
      end
      response
    end
  end
end