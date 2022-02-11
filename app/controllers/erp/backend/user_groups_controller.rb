module Erp
  module Backend
    class UserGroupsController < Erp::Backend::BackendController
      before_action :set_user_group, only: [:edit, :update, :deactivate, :activate]

      def index
      end

      def list
        @user_groups = UserGroup.search(params).paginate(page: params[:page], per_page: 20)
        render layout: nil
      end

      def new
        @user_group = UserGroup.new
      end

      def edit
      end

      def create
        @user_group = UserGroup.new(user_group_params)
        @user_group.creator = current_user
        if @user_group.save
          @user_group.update_permissions(params.to_unsafe_hash[:permissions])
          if request.xhr?
            render json: {status: 'success', text: @user_group.get_name, value: @user_group.id}
          else
            redirect_to erp.edit_backend_user_group_path(@user_group), notice: 'Tạo nhóm tài khoản mới thành công!'
          end
        else
          render :new
        end
      end

      def update
        if @user_group.update(user_group_params)
          @user_group.update_permissions(params.to_unsafe_hash[:permissions])
          if request.xhr?
            render json: {status: 'success', text: @user_group.get_name, value: @user_group.id}
          else
            redirect_to erp.edit_backend_user_group_path(@user_group), notice: 'Cập nhật nhóm tài khoản thành công!'
          end
        else
          render :edit
        end
      end

      def dataselect
        respond_to do |format|
          format.json {render json: UserGroup.dataselect(params[:keyword])}
        end
      end
      
      def deactivate
        @user_group.deactivate
        respond_to do |format|
          format.json {render json: {'message': 'Khóa nhóm tài khoản thành công!', 'type': 'success'}}
        end
      end

      def activate
        @user_group.activate
        respond_to do |format|
          format.json {render json: {'message': 'Mở nhóm tài khoản thành công!', 'type': 'success'}}
        end
      end

      private
        def set_user_group
          @user_group = UserGroup.find(params[:id])
        end
        def user_group_params
          params.fetch(:user_group, {}).permit(:name, :description)
        end
    end
  end
end