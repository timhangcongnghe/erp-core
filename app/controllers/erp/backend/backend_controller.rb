module Erp::Backend
	class BackendController < Erp::ApplicationController
		before_action :authenticate_user!
		before_action :home_breadcrumb
		layout :set_layout
		
		# add default breadcrumb
		def home_breadcrumb
			add_breadcrumb t(:Home), erp.backend_path
		end
		
		private
			def set_layout
			  "erp/backend/index"
			end
	end
end