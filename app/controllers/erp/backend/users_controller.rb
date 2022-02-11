module Erp
  module Backend
    class UsersController < Erp::Backend::BackendController
      before_action :set_user, only: [:edit, :update, :deactivate, :activate]

      def index
      end

      def list
        @users = User.search(params).paginate(page: params[:page], per_page: 20)
        render layout: nil
      end

      def new
        @user = User.new
      end

      def edit
      end

      def create
        @user = User.new(user_params)
        @user.creator = current_user
        @user.permissions = params.to_unsafe_hash[:permissions].to_json
        if @user.save
          if request.xhr?
            render json: {status: 'success', text: @user.get_name, value: @user.id}
          else
            redirect_to erp.edit_backend_user_path(@user), notice: 'Tạo tài khoản mới thành công!'
          end
        else
          render :new
        end
      end

      def update
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end
        if @user.update(user_params)
          @user.permissions = params.to_unsafe_hash[:permissions].to_json
          @user.save
          if request.xhr?
            render json: {status: 'success', text: @user.get_name, value: @user.id}
          else
            redirect_to erp.edit_backend_user_path(@user), notice: 'Cập nhật tài khoản thành công!'
          end
        else
          render :edit
        end
      end

      def dataselect
        respond_to do |format|
          format.json {render json: User.dataselect(params[:keyword])}
        end
      end

      def deactivate
        @user.deactivate
        respond_to do |format|
          format.html {redirect_to erp.backend_users_path, notice: 'Khóa tài khoản thành công!'}
          format.json {render json: {'message': 'Khóa tài khoản thành công!', 'type': 'success'}}
        end
      end

      def activate
        @user.activate
        respond_to do |format|
          format.html {redirect_to erp.backend_users_path, notice: 'Mở tài khoản thành công!'}
          format.json {render json: {'message': 'Mở tài khoản thành công!', 'type': 'success'}}
        end
      end

      def save_filter
        filter = JSON.parse(params[:filters])
        current_user.update_filter(filter.first[0], filter.first[1])
        render plain: 'saved'
      end

      private
        def set_user
          @user = User.find(params[:id])
        end
        def set_users
          @users = User.where(id: params[:ids])
        end
        def user_params
          params.fetch(:user, {}).permit(:address, :avatar, :name, :email, :password, :timezone, :user_group_id)
        end
    end
  end
end