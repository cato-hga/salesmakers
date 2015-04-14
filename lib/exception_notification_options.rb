class ExceptionNotificationOptions
  def initialize environment_tag
    {
        email: {
            email_prefix: "[#{environment_tag}] ",
            sender_address: 'development@retaildoneright.com',
            exception_recipients: %w{smiles@retaildoneright.com aatkinson@retaildoneright.com},
            sections: %w{request person session environment backtrace}
        }
    }
  end
end