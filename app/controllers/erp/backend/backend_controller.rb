module Erp::Backend
	class BackendController < Erp::ApplicationController
		before_action :authenticate_user!
		layout :set_layout
		
		private
			def set_layout
			  "erp/backend/index"
			end
	end
end