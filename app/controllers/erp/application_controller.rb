module Erp
  class ApplicationController < ActionController::Base
    before_action :set_paper_trail_whodunnit
    
		if Erp::Core.available?("carts")
			# @todo add cart for application controller bescause User::Session login not run
			include Erp::Carts::Frontend::Concerns::CurrentCart
			before_action :set_cart
			include Erp::Carts::Frontend::Concerns::CurrentCompare
			before_action :set_compare
		end

		Dir.glob(Rails.root.join('engines').to_s + "/*") do |d|
			eg = d.split(/[\/\\]/).last
			if eg != "core" and Erp::Core.available?(eg)
				helper "Erp::#{eg.camelize}::Engine".constantize.helpers
			end
		end

		# @todo: seperate backend fronend api
		def after_sign_in_path_for(resource_or_scope)
			set_flash_message :notice, :signed_in
			if session[:current_view] == 'frontend'
				url_for('/')
			else
				erp.backend_path
			end
		end
  end
end
