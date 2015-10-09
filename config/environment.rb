# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Invoicing::Application.initialize!

silence_warnings do
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE unless Rails.env.production?
end