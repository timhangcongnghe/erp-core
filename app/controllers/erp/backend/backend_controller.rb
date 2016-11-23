module Erp::Backend
	class BackendController < Erp::ApplicationController
		before_action :authenticate_user!
		layout :set_layout
		
		def index
		end
		
		def after_sign_out_path_for(resource_or_scope)
			erp.backend_path
		end
		
		private
			def set_layout
			  "erp/backend"
			end
	end
end