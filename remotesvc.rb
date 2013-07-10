# remotesvc.rb
require 'sinatra'
require_relative 'helpers/gpio-handler.rb'
require_relative 'helpers/api-url-helper.rb'

get '/open' do

  keys = { 'hugovh' => 'hugovh-API-secret-key' }

  #gurl = build_url url, user
  #puts gurl
  apiHelper = ApiUrlHelper.new
  #apiHelper.check_url request.url, keys
  url = request.url
  if apiHelper.check_url url, keys
    gpio = GpioHandler.new
    gpio.run
  end
end

get '/test' do
  url = request.url.gsub request.path, ""
  url += "/open"
  user = {:id => 'hugovh', :private_key => 'hugovh-API-secret-key'}
  apiHelper = ApiUrlHelper.new
  url = apiHelper.build_url url, user

  redirect url
end

# sudo rvm install bundler
# sudo apt-get install ruby-dev
# sudo bundle install
# sudo ruby remotesvc.rb -o 0.0.0.0
