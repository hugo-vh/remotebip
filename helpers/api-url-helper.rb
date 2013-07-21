require 'openssl'
require 'base64'
require 'uri'
require 'cgi'

class ApiUrlHelper
  DELAY_MAX = 2 * 60

  def check_url(url, keys)
    uri = URI(url)

    # get the params values
    p = CGI.parse(uri.query)
    user_id = p["id"].first
    hash = p["hash"].first
    date = p["date"].first

    # remove the 'hash' param
    params = URI.decode_www_form(uri.query)
    uri.query = URI.encode_www_form params.delete_if {|p| p[0] == "hash" }

    # checks the values
    raise "Unknow user: '#{user_id}'" unless keys[user_id]

    ghash = hmac uri.to_s, keys[user_id]
    raise "HMAC is not valid" unless ghash == hash

    diff = Time.now.to_i - date.to_i
    raise "Delay max reached: #{diff} secs (max: #{DELAY_MAX} secs)" unless diff <= DELAY_MAX

    true
  end

  def build_url(url, user)
    uri = URI(url)

    params = []
    params << [:id, user[:id]]
    params << [:date, Time.now.to_i]
    uri.query = URI.encode_www_form(params)

    params << [:hash, hmac(uri.to_s, user[:private_key])]
    uri.query = URI.encode_www_form(params)

    uri.to_s
  end

  def hmac(message, key)
    hash  = OpenSSL::HMAC.digest('sha256', key, message)
    Base64.encode64(hash).strip()
  end
end