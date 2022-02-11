module Core
  class ApplicationMailer < ActionMailer::Base
    default from: 'kinhdoanh@timhangcongnghe.com'
    layout 'erp/mailer/index'
  end
end