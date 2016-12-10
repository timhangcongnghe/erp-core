module Erp::Backend
	class BackendController < Erp::ApplicationController
		before_action :authenticate_user!
		layout :set_layout
		before_action :set_locale
		
		def set_locale
			I18n.locale = params[:locale] || I18n.default_locale
		end
		
		def default_url_options
			{ locale: I18n.locale }
		end	
		
		private
			def set_layout
			  "erp/backend/index"
			end
	end
end