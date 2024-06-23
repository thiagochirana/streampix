require "uri"
require "net/http"
require "json"
require "openssl"
require "colorize"
require "cpf_cnpj"
require "sdk_ruby_apis_efi"
require "hashie"
require "kredis"
require "unidecoder"
require "byebug"

class EfipayService
  @options = {
    client_id: Enviroments.efipay_client_id,
    client_secret: Enviroments.efipay_secret,
    certificate: Enviroments.certificado_path,
    sandbox: Enviroments.is_develop_environment,
  }

  def self.gen_new_payment(donate)
    body = {
      calendario: {
        expiracao: 300,
      },
      valor: {
        original: sprintf("%.2f", donate.value),
      },
      chave: Enviroments.chave_pix,
      solicitacaoPagador: "Doação oríunda de livestream",
    }

    efipay = SdkRubyApisEfi.new(@options)
    response = efipay.pixCreateImmediateCharge(body: body)

    data_payment = {
      "code_status" => 200,
      "qrcode_url" => response["location"],
      "pix_copia_cola" => response["pixCopiaECola"],
      "exp_time" => response["calendario"]["expiracao"],
    }

    name = "qrcode_user_#{donate.nickname}"
    @pre_checkout = Kredis.hash name
    @pre_checkout.update("pixCopiaCola" => response["pixCopiaECola"], "txid" => response["txid"])

    Hashie::Mash.new data_payment
  end

  def self.consult(donate)
    VerifyPaymentJob.set(wait: 35.seconds).perform_later donate

    # TODO first request in 35segs
    # new consult_payment each 20 segs until status starts.with?("REMOV")

    #get response in redis and verify the response

  end

  def self.consult_payment(donate)
    name = "qrcode_user_#{donate.nickname}"
    checkout = Kredis.hash name
    data = checkout.to_h

    puts "REDIS >>  Veio do Redis #{checkout}"
    params = {
      txid: data[:txid],
    }

    efipay = SdkRubyApisEfi.new(@options)
    response = efipay.pixDetailCharge(params: params)
    data_resp = Hashie::Mash.new response

    resp = Kredis.string "status_#{name}"
    resp = data_resp
    data_resp
  end

  def self.get_access_token
    cred = RedisService.get "efipay_token"
    if cred.present?
      puts "Encontrado efipay token em redis".green
      return cred
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

    #SET em REDIS
    RedisService.put("efipay_token", json_response["access_token"], json_response["expires_in"])
    json_response["access_token"]
  end
end
