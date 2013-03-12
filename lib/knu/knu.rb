class Knu

  WEBSERVICE_URL = "https://c.knu.com.br/webservice"

  attr_reader :user, :password, :format

  def initialize(user, password, format = 2)
    @user     = user
    @password = password
    @format   = format
  end

  def receitaCPF(cpf)
    request_knu request_data("receitaCPF", cpf)
  end

  protected

  def request_data(function, param, extra = nil)
    builder = Nokogiri::XML::Builder.new(:encoding => "ISO-8859-1") do |xml|
      xml.dados do
        xml.usuario @user
        xml.senha   @password
        xml.funcao  function
        xml.param   param
        xml.param2  extra      if extra
        xml.retorno @format
      end
    end
    builder.to_xml
  end

  def request_knu(xml)
    request = HTTPI::Request.new(WEBSERVICE_URL)
    request.body = xml
    request.open_timeout = 10 # sec
    request.read_timeout = 30 # sec
    request.auth.ssl.verify_mode = :none

    response = HTTPI.post(request)
    parse_response(response.body)
  end

  def parse_response(response)
    JSON.parse(response)
  end

end
