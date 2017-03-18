module Erp
  class ApplicationController < ActionController::Base
		# @todo add cart for application controller bescause User::Session login not run
		include Erp::Carts::Frontend::Concerns::CurrentCart
		before_action :set_cart
		
		Dir.glob(Rails.root.join('engines').to_s + "/*") do |d|
			eg = d.split(/[\/\\]/).last
			if eg != "core" and Erp::Core.available?(eg)
				helper "Erp::#{eg.camelize}::Engine".constantize.helpers
			end
		end
		
		# @todo: seperate backend fronend api
		def after_sign_in_path_for(resource_or_scope)
			if session[:current_view] == 'frontend'
				url_for('/')
			else
				erp.backend_path
			end
		end
  end
end
