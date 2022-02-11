$:.push File.expand_path('../lib', __FILE__)
require 'erp/core/version'
Gem::Specification.new do |s|
  s.name        = 'erp_core'
  s.version     = Erp::Core::VERSION
  s.authors     = 'Công Ty TNHH Giải Pháp CNTT Và Truyền Thông Hoàng Khang'
  s.email       = 'kinhdoanh@hoangkhang.com.vn'
  s.homepage    = 'https://timhangcongnghe.com/'
  s.summary     = 'Tìm Hàng Công Nghệ'
  s.description = 'Tìm Hàng Công Nghệ là đơn vị cung cấp các sản phẩm, dịch vụ thuộc lĩnh vực Công Nghệ Thông Tin do Công Ty TNHH Giải Pháp CNTT Và Truyền Thông Hoàng Khang phụ trách và phát triển.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails'
  s.add_dependency 'devise'
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
  s.add_dependency 'wkhtmltopdf-binary-edge'
  s.add_dependency 'roo'
  s.add_dependency 'dropbox-sdk-v2'
  s.add_dependency 'google_drive'
  s.add_dependency 'paper_trail'
end