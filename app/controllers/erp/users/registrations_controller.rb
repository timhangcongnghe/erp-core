module Erp
  module Users
    class RegistrationsController < Devise::RegistrationsController
      layout :set_layout
    
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