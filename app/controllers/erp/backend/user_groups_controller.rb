module Erp
  module Backend
    class UserGroupsController < Erp::Backend::BackendController
      before_action :set_user_group, only: [:edit, :update]

      # GET /user_groups
      def index
      end

      # POST /user_groups/list
      def list
        @user_groups = UserGroup.search(params).paginate(:page => params[:page], :per_page => 10)

        render layout: nil
      end

      # GET /user_groups/new
      def new
        @user_group = UserGroup.new
      end

      # GET /user_groups/1/edit
      def edit
      end

      # POST /user_groups
      def create
        @user_group = UserGroup.new(user_group_params)

        if @user_group.save
          if request.xhr?
            render json: {
              status: 'success',
              text: @user_group.name,
              value: @user_group.id
            }
          else
            redirect_to erp.edit_backend_user_group_path(@user_group), notice: 'UserGroup was successfully created.'
          end
        else
          render :new
        end
      end

      # PATCH/PUT /user_groups/1
      def update
        if @user_group.update(user_group_params)

          if request.xhr?
            render json: {
              status: 'success',
              text: @user_group.name,
              value: @user_group.id
            }
          else
            redirect_to erp.edit_backend_user_group_path(@user_group), notice: t('.success')
          end
        else
          render :edit
        end
      end

      def dataselect
        respond_to do |format|
          format.json {
            render json: UserGroup.dataselect(params[:keyword])
          }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user_group
          @user_group = UserGroup.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def user_group_params
          params.fetch(:user_group, {}).permit(:name, :description)
        end
    end
  end
end