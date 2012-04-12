# For MiniMagick https://forums.hostingplayground.com/showthread.php?p=3477
ENV['PATH'] = "#{ENV['PATH']}:/usr/local/bin"

# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_external = "UTF-8"
# Initialize the rails application
CheckinReloaded::Application.initialize!
