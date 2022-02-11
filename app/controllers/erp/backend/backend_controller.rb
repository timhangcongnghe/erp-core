require_dependency 'erp/application_controller'
module Erp::Backend
	class BackendController < Erp::ApplicationController
		layout :set_layout
		before_action :set_locale
		before_action :set_view
		before_action :authenticate_user!
		before_action :check_backend_access

		rescue_from CanCan::AccessDenied do |exception|
			render file: 'erp/static/403.html', status: 403, layout: false
		end

		def current_ability
			@current_ability ||= Erp::Ability.new(current_user)
		end

		def set_locale
			I18n.locale = params[:locale] || I18n.default_locale
		end

		def default_url_options
			{locale: I18n.locale}
		end

		def check_backend_access
			if !current_user.present? or !current_user.backend_access
				render plain: 'Quyền của bạn hiện tại không được phép truy cập. Vui lòng liên hệ Administrator để được hỗ trợ!'
			end
		end

		private
			def set_layout
				if request.xhr?
					nil
				else
					'erp/backend/index'
				end
			end

			def set_view
				session[:current_view] = 'backend'
			end
	end
end