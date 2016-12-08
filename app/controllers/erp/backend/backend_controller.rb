module Erp::Backend
	class BackendController < Erp::ApplicationController
		before_action :authenticate_user!
		layout :set_layout
		before_action :set_locale
		
		def set_locale
			I18n.locale = params[:locale] || I18n.default_locale
		end
		
		def extract_locale_from_tld
			parsed_locale = request.host.split('.').last
			I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
		end
		
		def default_url_options(options = {})
			{ locale: I18n.locale }.merge options
		end
		
		private
			def set_layout
			  "erp/backend/index"
			end
	end
end