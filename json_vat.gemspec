$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "json_vat"
  s.version     = '1.1.0'
  s.authors     = ["Adam Cooke"]
  s.email       = ["me@adamcooke.io"]
  s.homepage    = "http://github.com/adamcooke/json-vat"
  s.licenses    = ['MIT']
  s.summary     = "A client library for jsonvat.com"
  s.description = "Allows you to easily lookup VAT rats for EU countries based on the data from jsonvat.com."
  s.files = Dir["{lib}/**/*"]
  s.add_dependency "json", "~> 1.7"
end
