class Feedback < MailForm::Base
  attribute :person, validate: true
  attribute :email, validate: true
  attribute :message
  attribute :subject
  #This is for a check against bots sending spam. See this article: http://rubyonrailshelp.wordpress.com/2014/01/08/rails-4-simple-form-and-mail-form-to-make-contact-form/
  attribute :nickname, captcha: true


  def headers
    {
        from: 'development@retaildoneright.com',
        subject: subject,
        to: 'development@retaildoneright.com',
    }
  end
end