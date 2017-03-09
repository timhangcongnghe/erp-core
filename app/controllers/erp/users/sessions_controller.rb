module Erp
	class Users::SessionsController < Devise::SessionsController
		layout :set_layout
		
		private
			def set_layout
				if session[:current_view] == 'frontend'
					'erp/frontend/index'
				else
					"erp/backend/login"
				end
			end
	end
end