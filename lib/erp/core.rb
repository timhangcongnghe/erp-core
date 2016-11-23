require 'devise'

module Erp
	module Core
		def self.available?(engine_name)
			Object.const_defined?("Erp::#{engine_name.to_s.camelize}")
    end
	end
end
