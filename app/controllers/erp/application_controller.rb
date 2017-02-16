module Erp
  class ApplicationController < ActionController::Base
		before_action	:authenticate_user!
		
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
  end
end
