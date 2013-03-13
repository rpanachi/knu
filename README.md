KNU
=============

Client de consulta do KNU via WebService. Mais informações: https://knu.com.br/ajuda/documentacao/webservice

Instalação
------------

    gem install knu

Utilização
----------

    require "knu"

    knu = Knu.new("usuario@server.com", "senhaknu")
    knu.receitaCPF("12345678900")

    # {"@metodo"=>"receitaCPF", "nome"=>"FULANO DE TAL", "situacao"=>"REGULAR"}
