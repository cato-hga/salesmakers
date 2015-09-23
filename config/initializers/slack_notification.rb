class SlackJobNotifier
  def self.ping message
    return unless Rails.env.production?
    Slack::Notifier.new('https://hooks.slack.com/services/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').ping message
  end
end


