require 'eventmachine'

Thread.new do
  EM.run {
    ::GroupMeClient = Faye::Client.new 'https://push.groupme.com/faye'

    class GroupMeClientAuth
      def outgoing(message, callback)
        unless message['channel'] == '/meta/subscribe'
          return callback.call(message)
        end

        message['ext'] ||= {}

        message['ext']['access_token'] = '7a853610f0ca01310e5a065d7b71239d'
        message['ext']['timestamp'] = Time.now.to_i
        callback.call(message)
      end
    end

    GroupMeClient.add_extension GroupMeClientAuth.new

    class GroupMeSubscription
      def initialize(group_id)
        GroupMeClient.unsubscribe "/group/#{group_id}"
        GroupMeClient.subscribe "/group/#{group_id}" do |message|
          if message['type'] and message['type'] == 'favorite'
            GroupMeLike.create_from_json message['subject']
          end
        end
      end
    end

  }
end

puts 'Updating groups...'
GroupMeGroup.update_groups
puts 'Group updates complete.'