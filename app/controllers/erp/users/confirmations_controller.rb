module Erp
  class Users::ConfirmationsController < Devise::ConfirmationsController
    layout :set_layout

    private
      def after_confirmation_path_for(resource_name, resource)
        '/'
      end

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
