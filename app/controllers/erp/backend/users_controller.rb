module Erp
  module Backend
    class UsersController < Erp::ApplicationController
      def dataselect
        respond_to do |format|
          format.json {
            render json: User.dataselect(params[:keyword])
          }
        end
      end
    end
  end
end