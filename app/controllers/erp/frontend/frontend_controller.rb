require_dependency "erp/application_controller"

# @todo redundant code......
module Erp::Frontend
  class FrontendController < Erp::ApplicationController
    include Erp::ApplicationHelper
    before_action :set_view
		before_action :redirect_subdomain
	
		def redirect_subdomain
			if request.host == 'www.timhangcongnghe.com'
				redirect_to 'http://timhangcongnghe.com' + request.fullpath, :status => 301
			end
		end

    layout 'erp/frontend/index'

    def current_ability
			@current_ability ||= Erp::Ability.new(current_user)
		end

    private
			def set_view
				session[:current_view] = "frontend"
			end
  end
end
