class Enviroments
  @@teste = ENV["TESTE_ENV"]
  @@chave_pix = ENV["EFIPAY_CHAVE_PIX"]

  def self.efipay_client_id
    if is_develop_environment
      ENV["STREAMPIX_HOM_CLIENT_ID"]
    else
      ENV["STREAMPIX_PROD_CLIENT_ID"]
    end
  end

  def self.efipay_secret
    if is_develop_environment
      ENV["STREAMPIX_HOM_SECRET"]
    else
      ENV["STREAMPIX_PROD_SECRET"]
    end
  end

  def self.certificado_path
    if is_develop_environment
      ENV["STREAMPIX_CERT_HOM"]
    else
      ENV["STREAMPIX_CERT_PROD"]
    end
  end

  def self.efipay_url
    if is_develop_environment
      ENV["EFIPAY_URL_BASE_HOM"]
    else
      ENV["EFIPAY_URL_BASE_PROD"]
    end
  end

  def self.teste
    @@teste
  end

  def self.chave_pix
    @@chave_pix
  end

  def self.is_develop_environment
    environment = ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development"
    environment.downcase != "production"
  end
end
