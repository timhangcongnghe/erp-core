module Erp
  module Users
    class RegistrationsController < Devise::RegistrationsController
      layout :set_layout

      # POST /resource
      def create
        build_resource(sign_up_params)

        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            render plain: '<h2><i class="fa fa-user" aria-hidden="true"></i> Tạo tài khoản thành công</h2><p>Một email đã được gửi tới bạn với hướng dẫn xác minh tài khoản. Vui lòng kiểm tra email.</p>'
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def account_update_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
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
end
