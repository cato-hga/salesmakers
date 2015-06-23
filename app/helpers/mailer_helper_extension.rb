module MailerHelperExtension
  def mailer_h1 content
    content_tag :h1, content, style: "color: #E39000; font-family: sans-serif; text-transform: uppercase;"
  end

  def mailer_h2 content
    content_tag :h2, content, style: "color: #6D6E71; font-family: sans-serif;"
  end
end