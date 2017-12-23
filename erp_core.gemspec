$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "erp/core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "erp_core"
  s.version     = Erp::Core::VERSION
  s.authors     = ["Luan Pham",
                  "Son Nguyen",
                  "Hung Nguyen"]
  s.email       = ["luanpm@hoangkhang.com.vn",
                  "sonnn@hoangkhang.com.vn",
                  "hungnt@hoangkhang.com.vn"]
  s.homepage    = "http://globalnaturesoft.com/"
  s.summary     = "Core features of Erp System."
  s.description = "Core features of Erp System."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "devise"
  s.add_dependency 'will_paginate'
  s.add_dependency 'will_paginate-bootstrap'
  s.add_dependency 'carrierwave'
  s.add_dependency 'mini_magick'
  s.add_dependency 'rubyzip', '~> 1.1.0'
  s.add_dependency	'cancan'
  s.add_dependency 'unidecoder'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'omniauth-google-oauth2'
  s.add_dependency 'rmega'
  s.add_dependency 'axlsx', '2.1.0.pre'
  s.add_dependency 'axlsx_rails'
  s.add_dependency 'wicked_pdf'
  s.add_dependency 'wkhtmltopdf-binary'
  s.add_dependency 'roo'
  s.add_dependency 'dropbox-sdk-v2'
  s.add_dependency 'google_drive'
end
