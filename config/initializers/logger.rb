def time_in_ms(start, finish)
  return (((finish - start).to_f * 100000).round / 100.0)
end

if !Rails.env.test?
  # Controller action logging
  ActiveSupport::Notifications.subscribe("process_action.action_controller") do |name, start, finish, id, payload|
    logger = Log4r::Logger["#{Rails.env}_controllers"]

    controller_format = "@method @status @path @durationms"

    duration = time_in_ms(start, finish)

    if !payload[:exception].nil? || payload[:status] == 500
      #["process_action.action_controller", 0.033505, "b4ebe16ef3da4c5eb902", {:controller=>"MongotestController", :action=>"index", :params=>{"action"=>"index", "controller"=>"mongotest"}, :format=>:html, :method=>"GET", :path=>"/mongotest", :exception=>["Mongoid::Errors::DocumentNotFound", "\nPro   ...  "]}
      logger.error {
        message = controller_format.clone
        message.sub!(/@status/, payload[:status].to_s)
        message.sub!(/@method/, payload[:method])
        message.sub!(/@path/, payload[:path])
        message.sub!(/@duration/, duration.to_s)
        message += " EXCEPTION: #{payload[:exception]}"
        message
      }
    end

    if payload[:status] != 200 && payload[:status] != 500 && !payload[:exception].nil?
      logger.warn {
        message = controller_format.clone
        message.sub!(/@status/, payload[:status].to_s)
        message.sub!(/@method/, payload[:method])
        message.sub!(/@path/, payload[:path])
        message.sub!(/@duration/, duration.to_s)
        message += " EXCEPTION: #{payload[:exception]}"
        message
      }
    end

    if payload[:status] == 200
      if duration >= 500
        logger.warn {
          message = controller_format.clone
          message.sub!(/@status/, payload[:status].to_s)
          message.sub!(/@method/, payload[:method])
          message.sub!(/@path/, payload[:path])
          message.sub!(/@duration/, duration.to_s)
          message
        }
      else
        logger.info {
          message = controller_format.clone
          message.sub!(/@status/, payload[:status].to_s)
          message.sub!(/@method/, payload[:method])
          message.sub!(/@path/, payload[:path])
          message.sub!(/@duration/, duration.to_s)
          message
        }
      end
    end

    params = payload[:params]
    params = params.delete('photo') if params
    params = params.delete('image') if params
    params = params.delete('file') if params
    logger.info { "PARAMS: #{params.to_json }" }
    logger.debug {
      db = (payload[:db_runtime] * 100).round/100.0 rescue "-"
      view = (payload[:view_runtime] * 100).round/100.0 rescue "-"
      "TIMING[ms]: sum:#{duration.to_s} db:#{db} view:#{view}"
    }
  end

  # Mailer logging
  ActiveSupport::Notifications.subscribe "deliver.action_mailer" do |name, start, finish, id, payload|
    logger = Log4r::Logger["#{Rails.env}_mailers"]
    logger.info { "#{payload[:mailer]} - \"#{payload[:subject]}\" (#{payload[:to].join(', ')}) from #{payload[:from].join(', ')}" }
  end

  # Exception stack trace logging
  ActiveSupport::Notifications.subscribe "exception.action_controller" do |name, start, finish, id, payload|
    logger = Log4r::Logger["#{Rails.env}_errors"]
    logger.error { "msg:#{payload[:message]} - inspect:#{payload[:inspect]} - backtrace:#{payload[:backtrace].to_json}" }
  end
end