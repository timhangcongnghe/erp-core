require_dependency "erp/application_controller"

module Erp::Backend
	class BackendController < Erp::ApplicationController
		before_action :authenticate_user!
		layout :set_layout
		before_action :set_locale
		
		rescue_from CanCan::AccessDenied do |exception|
			render :file => "erp/static/403.html", :status => 403, :layout => false
		end
		
		def current_ability
			@current_ability ||= Erp::Ability.new(current_user)
		end
		
    # @todo: seperate backend fronend api
    def after_sign_out_path_for(resource_or_scope)
			erp.backend_path
		end
		
		def set_locale
			I18n.locale = params[:locale] || I18n.default_locale
		end
		
		def default_url_options
			{ locale: I18n.locale }
		end	
		
		private
			def set_layout
				if request.xhr?
					nil
				else
					"erp/backend/index"
				end			  
			end
	end
end