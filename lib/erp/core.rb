require 'devise'
require 'will_paginate'
require 'will_paginate-bootstrap'
require 'carrierwave'
require 'mini_magick'
require	'cancan'
require 'unidecoder'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require 'rmega'
require 'axlsx'
require 'axlsx_rails'
require 'wicked_pdf'
require 'roo'
# require 'wkhtmltopdf-binary'
require 'google_drive'
require 'paper_trail'

module Erp
	module Core
		def self.available?(engine_name)
			Object.const_defined?("Erp::#{engine_name.to_s.camelize}")
    end
	end
end
