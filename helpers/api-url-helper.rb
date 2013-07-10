require 'openssl'
require 'base64'
require 'uri'
require 'cgi'

class ApiUrlHelper
  DELAY_MAX = 10

  def check_url(url, keys)
    uri = URI(url)
    params = URI.decode_www_form(uri.query)
    p = CGI.parse(uri.query)

    user_id = p["id"].first
    hash = p["hash"].first
    date = p["date"].first

    diff = Time.now.to_i - date.to_i

    if diff > DELAY_MAX
      false
    else
      uri.query = URI.encode_www_form params.delete_if {|p| p[0] == "hash" }
      ghash = hmac uri.to_s, keys[user_id]
      ghash == hash
    end
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