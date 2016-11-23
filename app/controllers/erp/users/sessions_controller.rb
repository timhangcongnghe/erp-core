module Erp
	class Users::SessionsController < Devise::SessionsController
		layout :set_layout
		
		private
		def set_layout
			"erp/login"
		end
	end
end