ActionMailer::Base.smtp_settings = {
  :address              => Settings.app.mail.address,
  :port                 => Settings.app.mail.port,
  :domain               => Settings.app.mail.domain,
  :user_name            => Settings.app.mail.user_name,
  :password             => Settings.app.mail.password,
  :authentication       => Settings.app.mail.authentication,
  :enable_starttls_auto => Settings.app.mail.enable_starttls_auto
}

ActionMailer::Base.default_url_options[:host] = Settings.app.host
# Mail.register_interceptor(MailInterceptor) # if Rails.env.development?