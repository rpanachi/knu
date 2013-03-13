#encoding: UTF-8

require "spec_helper"

describe Knu do

  subject { Knu.new("user@server.com", "1234") }

  it { should respond_to(:user) }
  it { should respond_to(:password) }
  it { should respond_to(:format) }

  it "format json as default" do
    subject.format.should == :json
  end

  context "request" do

    context "build xml" do
      before do
        request_xml = subject.build_request_xml("function", "000")
        @doc = Nokogiri.XML(request_xml)
      end
      it { @doc.xpath("//dados/usuario").first.content.should == subject.user }
      it { @doc.xpath("//dados/senha").first.content.should == subject.password }
      it { @doc.xpath("//dados/funcao").first.content.should == "function" }
      it { @doc.xpath("//dados/param").first.content.should == "000" }
    end

    context "handle" do

      let :valid_response do
        %(
            <?xml version="1.0" encoding="utf-8"?>
            <dados>
                <status>0</status>
                <desc></desc>
                <consulta>
                    <root metodo="receitaCNPJ" arg="00000000000191">
                        <numero_inscricao>00.000.000/0001-91</numero_inscricao>
                        <data_abertura>01/08/1966</data_abertura>
                        <nome_empresarial>BANCO DO BRASIL SA</nome_empresarial>
                    </root>
                </consulta>
            </dados>
        )
      end

      let :invalid_response do
        %(
            <?xml version="1.0" encoding="utf-8"?>
            <dados>
                <status>55</status>
                <desc>Xml inválido</desc>
                <consulta></consulta>
            </dados>
        )
      end

      let :invalid_response_content do
        %(
            <?xml version="1.0" encoding="utf-8"?>
            <dados>
                <status>0</status>
                <desc></desc>
                <consulta>
                    <root metodo="receitaCNPJ" arg="00000000000190">
                        <cod_erro>6</cod_erro>
                        <desc_erro>Erro codigo 6: Parametro invalido.</desc_erro>
                    </root>
                </consulta>
            </dados>
        )
      end

      context "parse_response" do
        it "xml" do
          data = subject.parse_response(valid_response, :xml)
          data["dados"].should_not be_empty
        end

        it "json" do
          data = subject.parse_response(valid_response, :json)
          data["dados"].should_not be_empty
        end
      end

      context "validate data" do
        it "successfull" do
          data = Crack::XML.parse(valid_response)
          expect { subject.validate_data!(data) }.to_not raise_error
        end
        it "error category 1" do
          data = Crack::XML.parse(invalid_response)
          expect { subject.validate_data!(data) }.to raise_error
        end
        it "error category 2" do
          data = Crack::XML.parse(invalid_response_content)
          expect { subject.validate_data!(data) }.to raise_error
        end
      end

      context "response" do
        subject { Knu.new("email@server.com", "1234", :xml) }
        it "successfull" do
          result = subject.handle_response(valid_response)
          result["numero_inscricao"].should == "00.000.000/0001-91"
        end
      end
    end
  end

end
