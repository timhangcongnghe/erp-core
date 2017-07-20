module Erp
	class Users::PasswordsController < Devise::PasswordsController
    layout :set_layout

	# POST /resource/password
    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        render plain: '<h2><i class="fa fa-user" aria-hidden="true"></i> Lấy lại mật khẩu</h2><p>Một email đã được gửi tới bạn với hướng dẫn lấy lại mật khẩu. Vui lòng kiểm tra email.</p>'
      else
        respond_with(resource)
      end
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
