module Erp
  class ApplicationController < ActionController::Base
    
    # @todo: seperate backend fronend api
    def after_sign_out_path_for(resource_or_scope)
			erp.backend_path
		end
  end
end
