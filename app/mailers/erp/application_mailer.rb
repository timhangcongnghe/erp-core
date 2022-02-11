module Erp
  class ApplicationMailer < ActionMailer::Base
    default from: 'kinhdoanh@timhangcongnghe.com'
    layout 'erp/mailer/index'

    private
    def send_email(email, subject)
      delivery_options = {address: 'smtp.gmail.com', port: 587, domain: 'globalnaturesoft.com', user_name: 'soft.support@hoangkhang.com.vn', password: 'aA456321@#$', authentication: 'plain', enable_starttls_auto: true}
      mail(to: email, subject: subject, delivery_method_options: delivery_options)
    end
  end
end