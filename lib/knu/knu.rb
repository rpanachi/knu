#encoding: UTF-8

class Knu

  WEBSERVICE_URL = "https://c.knu.com.br/webservice"
  RETURN_FORMATS = {:json => 2, :xml => 1}
  STATUS_OK      = "0"

  FUNCTIONS = %w(
    receitaCPF
    receitaCNPJ
    receitaSimples
    fgtsCNPJ
    ibgeCodigo
    ibgeMunicipio
    consultarEndereco
    receitaCCD
    cadespCNPJ
    consultarNfeHtml
    sintegraAC_CNPJ
    sintegraAP_CNPJ
    sintegraAM_CNPJ
    sintegraBA_CNPJ
    sintegraDF_CNPJ
    sintegraCE_CNPJ
    sintegraMS_CNPJ
    sintegraPE_CNPJ
    sintegraPB_CNPJ
    sintegraRR_CNPJ
    sintegraTO_CNPJ
    sintegraRJ_CNPJ
    sintegraSE_CNPJ
    sintegraSP_CNPJ
    sintegraSU
    denatran
    detranSP
  )

  attr_reader :user, :password, :format

  def initialize(user, password, format = :json)
    @user     = user
    @password = password
    @format   = format
  end

  FUNCTIONS.each do |function|
    define_method(function.to_sym) do |param, extra = nil|
      data     = build_request_xml(function, param, extra)
      response = request(data)
    end
  end

  # builds the standard request xml
  def build_request_xml(function, param, extra = nil)
    xml = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n"
    xml << "<dados>\n"
    xml << "  <usuario>#{@user}</usuario>\n"
    xml << "  <senha>#{@password}</senha>\n"
    xml << "  <funcao>#{function}</funcao>\n"
    xml << "  <param>#{param}</param>\n"
    xml << "  <param2>#{extra}</param2>\n" if extra
    xml << "  <retorno>#{RETURN_FORMATS[@format]}</retorno>\n"
    xml << "</dados>"
    xml
  end

  def request(xml)
    request = HTTPI::Request.new(WEBSERVICE_URL)
    request.body = xml
    request.open_timeout = 10 # sec
    request.read_timeout = 30 # sec
    request.auth.ssl.verify_mode = :none

    response = HTTPI.post(request)
    handle_response(response.body)
  end

  def handle_response(response)
    data = parse_response(response)
    validate_data!(data)
    data["dados"]["consulta"]["root"]
  end

  def validate_data!(data)
    dados = data["dados"]
    unless (status = dados["status"]) == STATUS_OK
      raise "Error #{status}: " + dados["desc"]
    else
      root = dados["consulta"]["root"]
      if error = root["cod_erro"]
        raise "Error #{error}: " + root["desc_erro"]
      end
    end
  rescue => ex
    raise "Invalid response: #{ex.message}"
  end

  def parse_response(response, format = @format)
    case format
      when :json
        Crack::JSON.parse(response)
      when :xml
        Crack::XML.parse(response)
    end
  end

end
