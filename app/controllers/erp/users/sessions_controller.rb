module Erp
	class Users::SessionsController < Devise::SessionsController
		layout :set_layout

		def new
			self.resource = resource_class.new(sign_in_params)
			clean_up_passwords(resource)
			yield resource if block_given?
			respond_with(resource, serialize_options(resource))
		end

		private
			def set_layout
				return nil if request.xhr?

				if session[:current_view] == 'frontend'
					'erp/frontend/index'
				else
					"erp/backend/login"
				end
			end
	end
end
