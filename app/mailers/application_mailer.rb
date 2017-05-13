class ApplicationMailer < ActionMailer::Base
  default from: %("apiwoods Team" <noreply@apiwoods.com>)
  layout 'mailer'
end
