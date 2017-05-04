module Erp
  class Users::ConfirmationsController < Devise::ConfirmationsController
    layout :set_layout

    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message!(:notice, :confirmed)
        respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      else
        flash[:notice] = "Your account is already confirmed. Please login."
        redirect_to '/#sign-in'
      end
    end

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
