require_dependency "erp/application_controller"

module Erp::Frontend
  class FrontendController < Erp::ApplicationController
    before_filter :set_view
    
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