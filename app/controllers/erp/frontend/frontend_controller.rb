require_dependency "erp/application_controller"

module Erp::Frontend
  class FrontendController < Erp::ApplicationController
		include Erp::Carts::Frontend::Concerns::CurrentCart
		before_action :set_cart
    before_filter :set_view
    
    layout 'erp/frontend/index'
    
    private
			def set_view
				session[:current_view] = "frontend"
			end
  end
end