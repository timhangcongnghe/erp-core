module Erp
  module Backend
    class AccountsController < Erp::Backend::BackendController
      before_action :set_user, only: [:profile, :update_user, :update_password]
      before_action :set_contact, only: [:profile, :update_contact]
      
      def profile
      end
      
      def update_contact
        if params[:contact].present?
          @contact.assign_attributes(contact_params)
          @contact.creator = current_user
          @contact.contact_type = params[:contact_type].present? ? params[:contact_type] : Erp::Contacts::Contact::TYPE_PERSON
          @contact.user = current_user
          if @contact.save
            redirect_to erp.profile_backend_accounts_path(tab: 'personal'), flash: {success: 'Thông tin tài khoản đã được cập nhật thành công!'}
          else
            redirect_to erp.profile_backend_accounts_path(tab: 'personal'), flash: {error: 'Thông tin tài khoản chưa được cập nhật. Vui lòng kiểm tra và thử lại!'}
          end
        end
      end
      
      def update_user
        if params[:user].present?
          if @user.update(user_params)
            redirect_to erp.profile_backend_accounts_path(tab: 'account'), flash: {notice: 'Tài khoản đã được cập nhật thành công!'}
          else
            redirect_to erp.profile_backend_accounts_path(tab: 'account'), flash: {error: 'Tài khoản chưa được cập nhật. Vui lòng kiểm tra và thử lại!'}
          end
        end
      end
      
      def update_password
        if params[:user].present? and !@user.valid_password?(params[:user][:current_password])
          redirect_to erp.profile_backend_accounts_path(tab: 'password'), flash: {error: 'Mật khẩu hiện tại không chính xác. Vui lòng kiểm tra và thử lại!'}
          return
        end
        if params[:user].present?
          params[:user].delete(:password) if params[:user][:password].blank?
          params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
          if @user.update_with_password(user_params)
            bypass_sign_in(@user)
            redirect_to erp.profile_backend_accounts_path(tab: 'password'), flash: { notice: 'Mật khẩu mới đã được cập nhật thành công!'}
          else
            if params[:user][:password].nil? or params[:user][:password].length < 6
              redirect_to erp.profile_backend_accounts_path(tab: 'password'), flash: {error: 'Mật khẩu mới phải có ít nhất 6 ký tự. Vui lòng kiểm tra và thử lại!'}
            else
              redirect_to erp.profile_backend_accounts_path(tab: 'password'), flash: {error: 'Mật khẩu không trùng khớp nhau. Vui lòng kiểm tra và thử lại!'}
            end
          end
        end
      end

      private
        def set_user
          @user = current_user
        end
        
        def set_contact
          @contact = !current_user.contact.nil? ? current_user.contact : Erp::Contacts::Contact.new(user_id: current_user.id)
        end

        def user_params
          params.fetch(:user, {}).permit(:address, :avatar, :name, :current_password, :password, :password_confirmation)
        end
        
        def contact_params
          params.fetch(:contact, {}).permit(:name, :phone, :email, :birthday, :state_id, :district_id, :address)
        end
    end
  end
end