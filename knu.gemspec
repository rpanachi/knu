#encoding: UTF-8
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "knu/version"

Gem::Specification.new do |gem|
  gem.name          = "knu"
  gem.version       = Knu::VERSION
  gem.date          = "2012-03-12"
  gem.summary       = "Client Knu Webservice"
  gem.description   = "Client Knu Webservice"
  gem.authors       = ["Rodrigo Panachi"]
  gem.email         = "rpanachi@gmail.com"
  gem.files         = ["lib/knu.rb"]
  gem.homepage      = 'https://github.com/rpanachi/knu'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "rack"
  gem.add_runtime_dependency "httpi"
  gem.add_runtime_dependency "nokogiri"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
