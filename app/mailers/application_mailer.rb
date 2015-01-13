class ApplicationMailer < ActionMailer::Base
  default from: "development@retaildoneright.com"
  layout 'mailer'
  add_template_helper ApplicationHelper
end