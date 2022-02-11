require_dependency 'erp/application_controller'
module Erp::Frontend
  class FrontendController < Erp::ApplicationController
    include Erp::ApplicationHelper
		
		layout :set_layout
    before_action :set_view
		before_action :redirect_subdomain

    def current_ability
			@current_ability ||= Erp::Ability.new(current_user)
		end

		def redirect_subdomain
			if request.host == 'www.timhangcongnghe.com'
				redirect_to 'https://timhangcongnghe.com' + request.fullpath, status: 301
			end
		end

    private
			def set_layout
				if request.xhr?
					nil
				else
					'erp/frontend/index'
				end
			end
			def set_view
				session[:current_view] = 'frontend'
			end
  end
end