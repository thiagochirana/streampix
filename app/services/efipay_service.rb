require "uri"
require "net/http"
require "json"
require "openssl"
require "colorize"

class EfipayService
  def self.get_access_token
    cred = RedisService.get "efipay"
    if cred.present? && cred.key?(:access_token)
      puts "Encontrado efipay token em redis".green
      return cred[:access_token]
    else
      puts "Nada de token efipay encontrado em Redis, buscar outro na API".yellow
    end

    client_id = Enviroments.efipay_client_id
    client_secret = Enviroments.efipay_secret

    certfile = File.read(Enviroments.certificado_path)

    url = URI("#{Enviroments.efipay_url}/oauth/token")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.cert = OpenSSL::X509::Certificate.new(certfile)
    https.key = OpenSSL::PKey::RSA.new(certfile)

    request = Net::HTTP::Post.new(url)
    request.basic_auth(client_id, client_secret)
    request["Content-Type"] = "application/json"
    request.body = "{\r\n    \"grant_type\": \"client_credentials\"\r\n}"

    response = https.request(request)
    json_response = JSON.parse(response.body)

    json_obj = {
      "access_token" => json_response["access_token"],
      "token_type" => json_response["bearer"],
      "expires_in" => json_response["expires_in"],
      "scope" => json_response["scope"],
    }

    #SET em REDIS
    RedisService.put("efipay", json_obj, json_response["scope"])
    json_obj[:acess_token]
  end
end
