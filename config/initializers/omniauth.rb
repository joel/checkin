Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, Settings.app.omniauth.twitter.key, Settings.app.omniauth.twitter.secret
  provider :facebook, Settings.app.omniauth.facebook.key, Settings.app.omniauth.facebook.secret # , { :scope => "permission scope" } 
  provider :google, Settings.app.omniauth.google.key, Settings.app.omniauth.google.secret
  provider :github, Settings.app.omniauth.github.key, Settings.app.omniauth.github.secret
  # require 'openid/store/filesystem'  
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'aol', :identifier => 'openid.aol.com'
  # provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'myopenid', :identifier => 'myopenid.com'
end
OmniAuth.config.full_host = Settings.app.omniauth.host