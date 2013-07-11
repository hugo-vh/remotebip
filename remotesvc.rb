# remotesvc.rb
require 'sinatra'
require_relative 'helpers/hardware-helper.rb'
require_relative 'helpers/api-url-helper.rb'

KEYS_DB = { 'hugovh' => 'hugovh-API-secret-key' }
RESPONSE_OK = "Ok"
RESPONSE_KO = "Ko"

get '/open' do
  url = request.url
  if url_helper.check_url url, KEYS_DB
    gpio.run
    RESPONSE_OK
  else
    RESPONSE_KO
  end
end

get '/test' do
  valid_url_for_user({id: 'hugovh', private_key: 'hugovh-API-secret-key'})
end

def url_helper
  ApiUrlHelper.new
end

def gpio
  HardwareHelper.new
end

def valid_url_for_user user
  ApiUrlHelper.new.build_url open_url, user
end

def open_url
  (request.url.gsub request.path, "") + "/open"
end

# sudo gem install bundler
# sudo apt-get install ruby-dev
# sudo bundle install
# sudo ruby remotesvc.rb -o 0.0.0.0
