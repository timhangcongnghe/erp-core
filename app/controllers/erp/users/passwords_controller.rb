module Erp
	class Users::PasswordsController < Devise::PasswordsController
    layout :set_layout

    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?
      if successfully_sent?(resource)
        render plain: '<h2><i class="fa fa-user" aria-hidden="true"></i> Lấy Lại Mật Khẩu</h2><p>Một email hướng dẫn lấy lại mật khẩu đã được gửi tới bạn. Vui lòng kiểm tra hộp thư mail.</p>'
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
          'erp/backend/login'
        end
      end
	end
end