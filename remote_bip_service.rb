# remotesvc.rb
require 'sinatra/base'
require_relative 'helpers/hardware-helper.rb'
require_relative 'helpers/api-url-helper.rb'

class RemoteBipService < Sinatra::Base
  KEYS_DB = { 'hugovh' => 'hugovh-API-secret-key' }

  get '/open' do
    begin
      url = request.url

      puts url
      logger.info url

      if url_helper.check_url url, KEYS_DB
        logger.info "Welcome !"
        gpio.run
      else
        logger.error "Move out!"
      end
    rescue Exception => e
      puts e.message
      logger.error e.message
    end
  end

  #get '/test' do
  #  valid_url_for_user({id: 'hugovh', private_key: 'hugovh-API-secret-key'})
  #end

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

  def logger
   logger ||= Logger.new('logs/remotebip.log', 'monthly')
  end
end

RemoteBipService.run! bind: '0.0.0.0', port: 4567, environment: :development

# sudo gem install bundler
# sudo apt-get install ruby-dev
# sudo bundle install
# sudo ruby remotesvc.rb -o 0.0.0.0
